from flask import Flask
from flask import jsonify
from flask import send_file
from flask import request
from flask import make_response
import qrcode
from io import BytesIO
from urllib.parse import unquote

app_name = 'comentarios'
app = Flask(app_name)
app.debug = True

comments = {}

@app.route('/api/qrcode', methods=['GET'])
def api_qrcode():

    url = request.args.get('url', type = str)

    input_data = unquote(url or "https://globoplay.globo.com") #Creating an instance of qrcode
    qr = qrcode.QRCode(
            version=1,
            box_size=10,
            border=5)
    qr.add_data(input_data)
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white')
    img_io = BytesIO()
    img.save(img_io, 'JPEG', quality=70)
    img_io.seek(0)

    response = make_response(send_file(img_io, mimetype="image/jpeg", as_attachment=False))
    response.headers['Content-Disposition'] = 'inline'

    return response

@app.route('/api/comment/new', methods=['POST'])
def api_comment_new():
    request_data = request.get_json()

    email = request_data['email']
    comment = request_data['comment']
    content_id = '{}'.format(request_data['content_id'])

    new_comment = {
            'email': email,
            'comment': comment,
            }

    if content_id in comments:
        comments[content_id].append(new_comment)
    else:
        comments[content_id] = [new_comment]

    message = 'comment created and associated with content_id {}'.format(content_id)
    response = {
            'status': 'SUCCESS',
            'message': message,
            }
    return jsonify(response)


@app.route('/api/comment/list/<content_id>')
def api_comment_list(content_id):
    content_id = '{}'.format(content_id)

    if content_id in comments:
        return jsonify(comments[content_id])
    else:
        message = 'content_id {} not found'.format(content_id)
        response = {
                'status': 'NOT-FOUND',
                'message': message,
                }
        return jsonify(response), 404