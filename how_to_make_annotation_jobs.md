# iKut Annotation - How to define an annotation job

# What is iKut Annotation

This app is the annotation tool to create training data for developing image classification models.
Labeling workers can manually annotates label to multiple images.

# Overview

This document describes how developers define an annotation job.

# Annotation job configuration

An annotation job consists of the following files.

- A YAML file
- Image files

Both must be HTTPS hosted. Workers can start an annotation job by entering the URL of athe YAML file.

# A YAML file

| key | value |
| --- | --- |
| labels | Array of all labels (2-4) |
| images | Array of images to be annotated |

Elements of `images`.

| key | value |
| --- | --- |
| label | The label of image |
| url | URL of image (`https://` schema) |

## Example

```yaml
labels:
- takoyaki
- sushi
- gyoza
- other
images:
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002013.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002167.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1002237.jpg
- label: takoyaki
  url: https://ikut-annotation-sample.web.app/image/1003289.jpg
- label: sushi
  url: https://ikut-annotation-sample.web.app/image/100332.jpg
```
