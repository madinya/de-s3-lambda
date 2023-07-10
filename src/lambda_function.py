import os
from download import download_file
from upload import upload_s3
from util import upload_bookmark, get_next_file_name, get_prev_file_name


def lambda_handler(event, context):
    upload_res = None
    bucket_name = os.environ.get('BUCKET_NAME')
    bookmark_file = os.environ.get('BOOKMARK_FILE')
    baseline_file = os.environ.get('BASELINE_FILE')
    file_prefix = os.environ.get('FILE_PREFIX')
    while True:
        prev_file_name = get_prev_file_name(bucket_name, file_prefix, bookmark_file, baseline_file)
        file_name = get_next_file_name(prev_file_name)
        download_res = download_file(file_name)
        if download_res.status_code == 404:
            print(f'Invalid file name or downloads caught up till {prev_file_name}')
            break
        upload_res = upload_s3(
            download_res.content,
            bucket_name,
            f'{file_prefix}/{file_name}'
        )
        print(f'File {file_name} successfully processed')
        upload_bookmark(bucket_name, file_prefix, bookmark_file, file_name)
    return upload_res
