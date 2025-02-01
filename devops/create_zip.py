import os
import zipfile
from pathlib import Path

def create_deployment_zip():
    # Get the parent directory (project root)
    parent_dir = Path(__file__).parent.parent
    zip_path = parent_dir / 'deploy.zip'
    
    # Files to include
    files_to_zip = ['src', 'requirements.txt']
    
    # Create the zip file
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for file in files_to_zip:
            path = parent_dir / file
            if path.is_dir():
                # If it's a directory, add all files keeping the structure
                for root, _, files in os.walk(path):
                    for f in files:
                        file_path = Path(root) / f
                        arc_name = file_path.relative_to(parent_dir)
                        zipf.write(file_path, arc_name)
            else:
                # If it's a file, add it directly
                zipf.write(path, file)

if __name__ == '__main__':
    create_deployment_zip() 