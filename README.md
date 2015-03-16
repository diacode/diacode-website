# Diacode website & blog

Middleman project which includes Diacode Website and Blog.

## Blog

### Composing an article

Creating a new blog post is as simple as writing the following on the command line:

```
middleman article <POST TITLE>
```

This will create a new file on `source/blog/<POST DATE>-<POST TITLE>.html.markdown`.

### Attaching an image to an article

This is one of the ugly trade offs of choosing an static site as blog. In order to not have versioned content images within the repository we have to upload the pictures somewhere else. In our case that's **Amazon S3**.

You can upload an image to Amazon S3 by running the following command:

```
thor images:upload [PATH|URL]
```

It will output the URL of the asset so that you can include it the markdown document you desire.

## Deploy

*Not defined yet*.
