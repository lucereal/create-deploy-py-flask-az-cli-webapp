from flask import Blueprint, jsonify

email = Blueprint('email', __name__, url_prefix='/email')

@email.route('/', methods=['GET'])
def email_world():
    return jsonify({
        "success": True,
        "message": "Email API"
    }) 