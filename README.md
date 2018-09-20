## Independent Stove Installations

Jekyll generated website, deployed to Firebase CDN.

## Run locally

`bundle exec jekyll serve`

## Build the static site

Currently the static site is built in `_site/`

`bundle exec jekyll build`

## Deploy to Firebase

`firebase deploy`

## Image galleries

Image gallery data is stored in `_data/recent-installations.csv`.
This is used by the template `recent-installations.html` which iterates through
the CSV items and populates the HTML.
The image files are stored in an S3 bucket and served by Cloudfoundry CDN.
