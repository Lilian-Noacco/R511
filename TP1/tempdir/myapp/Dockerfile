FROM python:3.8-alpine
RUN apk update && apk add --no-cache build-base
RUN pip install Flask
WORKDIR /home/myapp
COPY . /home/myapp
EXPOSE 8080
CMD ["python", "flask_app.py"]
