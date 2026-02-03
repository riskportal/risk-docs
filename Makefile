# RISK Docs Makefile

format: ## Format only python files to line length 100
	black --line-length=100 ./
	make clean

clean: ## Remove caches, checkpoints, and distribution artifacts
	find . -type f -name ".DS_Store" | xargs rm -f
	find . -type d \( -name ".ipynb_checkpoints" -o -name "__pycache__" -o -name ".pytest_cache" \) | xargs rm -rf
	rm -rf dist/ build/ *.egg-info

build-notebook-docs: ## Rebuild Jupyter notebook docs by converting it to standalone HTML and ZIP
	rm -f docs/tutorial.html docs/tutorial.zip
	jupyter nbconvert --to html notebooks/tutorial.ipynb --output-dir docs
	cd notebooks && zip -r ../docs/tutorial.zip tutorial.ipynb data

deploy-docs: ## Deploy docs using mkdocs to GitHub Pages
	mkdocs gh-deploy --clean
