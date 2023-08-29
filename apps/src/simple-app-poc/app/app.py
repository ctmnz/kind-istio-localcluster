from flask import Flask, render_template, request
import time
import libs.nc as netcat

app = Flask(__name__,
        static_url_path='/static',
        static_folder='static',
        template_folder='templates')


@app.route('/')
def index():
    return render_template('index-admin.html')

@app.route('/admin')
def admin():
    return render_template('index-admin.html')

@app.route('/aws-rds-check')
def aws_rds_check():
    return render_template('aws-rds-checker.html')

@app.route('/aws-redis-check')
def aws_redis_check():
    return render_template('aws-redis-checker.html')

@app.route('/aws-rabbitmq-check')
def aws_rabbitmq_check():
    return render_template('aws-rabbitmq-checker.html')

@app.route('/netcat')
def web_netcat():
    return render_template('netcat.html')



# API
# http://localhost:5000/api/netcat?host=google.com&port=80&timeout=1

@app.route('/api/netcat')
def do_netcat():
    host = request.args.get('host')
    port = request.args.get('port')
    timeout = request.args.get('timeout')
    response = netcat.netcat(host, port, timeout)
    return response

@app.route('/time')
def get_current_time():
    return {'time': time.time()}

