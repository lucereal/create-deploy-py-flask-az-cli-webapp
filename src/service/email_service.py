import os
import smtplib
from email.message import EmailMessage
from typing import Optional
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class EmailService:
    def __init__(self):
        # Get SMTP configuration from environment variables
        self.smtp_server = os.getenv('SMTP_SERVER', 'smtp.gmail.com')
        self.smtp_port = int(os.getenv('SMTP_PORT', '587'))
        self.smtp_username = os.getenv('SMTP_USERNAME')
        self.smtp_password = os.getenv('SMTP_PASSWORD')
        
        if not all([self.smtp_username, self.smtp_password]):
            raise ValueError("SMTP credentials not properly configured in environment variables")

    def send_email(self, to_email: str, subject: str, content: str, from_email: Optional[str] = None) -> bool:
        """
        Send an email using configured SMTP server.
        
        Args:
            to_email (str): Recipient's email address
            subject (str): Email subject
            content (str): Email body content
            from_email (Optional[str]): Sender's email address. Defaults to SMTP_USERNAME if not provided.
            
        Returns:
            bool: True if email was sent successfully, False otherwise
            
        Raises:
            smtplib.SMTPException: If there's an error sending the email
        """
        try:
            # Create the email message
            msg = EmailMessage()
            msg.set_content(content)
            
            # Set email headers
            msg['Subject'] = subject
            msg['From'] = from_email or self.smtp_username
            msg['To'] = to_email
            
            # Connect to SMTP server and send email
            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.starttls()  # Enable TLS
                server.login(self.smtp_username, self.smtp_password)
                server.send_message(msg)
                
            return True
            
        except smtplib.SMTPException as e:
            print(f"Failed to send email: {str(e)}")
            return False
