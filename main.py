from src.lambda_function import lambda_handler

if __name__ == "__main__":
    res = lambda_handler(None, None)
    print(res)