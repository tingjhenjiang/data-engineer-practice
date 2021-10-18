from __future__ import unicode_literals
from flask import Flask, request, render_template, abort, jsonify
from flask_restful import Resource, Api

app = Flask(__name__,template_folder='templates')
api = Api(app)

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

class apiresource_youtubedl(Resource):
    def __init__(self):
        super(apiresource_youtubedl, self).__init__()
        with open('qualified_token.txt') as f:
            qualified_token = f.readlines()
        self.qualified_token = qualified_token[0]

    def get(self):
        source_video_page_url = request.args.get('url', None)
        req_token = request.args.get('token', None)
        if self.qualified_token==req_token:
            from youtubedl.youtube_dl import YoutubeDL
            ydl_opts = {}
            self.ydl = YoutubeDL(ydl_opts)
            r = self.ydl.extract_info(source_video_page_url, download=False)
            urls = [f['url'] for f in r['formats'] if f['acodec'] != 'none' and f['vcodec'] != 'none']
            returndata = {
                **{'source_video_page_url': source_video_page_url},
                **r,
                **{'streamingurls': urls},
                **{'highestres_streamingurl':urls[-1]}
            }
            returndata = jsonify(returndata)
            return returndata
        else:
            abort(404)

api.add_resource(apiresource_youtubedl, '/ydl')

#if __name__ == '__main__':
#    app.run(debug=True, host='0.0.0.0', port=80)