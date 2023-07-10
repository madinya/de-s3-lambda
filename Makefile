PACKAGE_NAME = lambda_function.zip
VENV_DIR = venv
SRC_DIR = src
S3_BUCKET = dev-de-s3-lambda
LIB_REQUIREMENTS = $(VENV_DIR)/requirements/

.PHONY: package clean upload install venv

package: install
	@echo "Creating package..."
	@cd $(SRC_DIR) && zip -r ../$(PACKAGE_NAME) ./*
	@cd $(LIB_REQUIREMENTS) && zip -ur ../../$(PACKAGE_NAME) ./*
	@echo "Package created: $(PACKAGE_NAME)"

upload:
	@echo "Uploading package to S3..."
	@aws s3 cp $(PACKAGE_NAME) s3://$(S3_BUCKET)/$(PACKAGE_NAME)
	@echo "Package uploaded to S3: $(S3_BUCKET)/$(PACKAGE_NAME)"

install: venv
	@echo "Installing dependencies..."
	@$(VENV_DIR)/bin/pip install -r requirements.txt -t $(LIB_REQUIREMENTS)
	@echo "Dependencies installed."

venv:
	@echo "Creating virtual environment..."
	@python3 -m venv $(VENV_DIR)
	@echo "Virtual environment created."

clean:
	@echo "Cleaning up..."
	@rm -f $(PACKAGE_NAME)
	@rm -rf $(VENV_DIR)/requirements/
	@echo "Cleanup complete."