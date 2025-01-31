from flask import Blueprint, jsonify

hello = Blueprint('hello', __name__, url_prefix='/api')

@hello.route('/hello', methods=['GET'])
def hello_world():
    return jsonify({
        "success": True,
        "message": "Hello, World!"
    }) 