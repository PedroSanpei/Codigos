"""
                                        CONTEÚDOS UTILIZADOS PARA MONTAR ESSA API

1- https://www.youtube.com/watch?v=30PINAI8eyo = Google Drive App - OAuth Setup Workflow 
2- https://www.youtube.com/watch?v=9K2P2bWEd90&t=353s = Google Drive API in Python | Getting Started
3- https://www.youtube.com/watch?v=cCKPjW5JwKo&t=12s = Google Drive API in Python | Upload Files
4- https://learndataanalysis.org/google-drive-api-in-python-getting-started-lesson-1/ = Google Drive API in Python | Getting Started (Lesson #1) 


"""
# IMPORTANDO BIBLIOTECAS

from Google import Create_Service
from googleapiclient.http import MediaFileUpload
import glob
import os

# LISTAR ARQUIVOS NA PASTA
list_of_files = glob.glob('./Teste/*')
# PEGAR ARQUIVOS RECENTES
latest_file = max(list_of_files, key=os.path.getctime)
file = str(latest_file)[8:]
print(file)

# CONFIGURAÇÃO API GOOGLE DRIVE
CLIENT_SECRET_FILE = 'CLIENT_SECRET.json'
API_NAME = 'drive'
API_VERSION = 'v3'
SCOPES = ['https://www.googleapis.com/auth/drive']

service = Create_Service(CLIENT_SECRET_FILE,API_NAME,API_VERSION,SCOPES)

folder_id = f'1rvEotpbwb-jTacLXVZ7W1IVsOTA5o1tm'
file_names = [f'{file}']
mime_types = ['image/jpeg','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']

# CRIANDO O CORPO DA SUBIDA DOS ARQUIVOS
for file_name, mime_type in zip(file_names, mime_types):
    file_metadata = {
        'name': file_name,
        'parents': [folder_id]

    }
    
# CRIANDO A MEDIA
    media = MediaFileUpload('./Teste/{0}'.format(file_name), mimetype=mime_type)

#SUBINDO OS ARQUIVOS   
    service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()