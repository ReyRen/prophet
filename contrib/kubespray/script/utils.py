import logging
import logging.config
import yaml
import jinja2

def setup_logger_config(logger):
    """
        Setup logging configuration
    """
    if len(logger.handlers) == 0:
        logger.propagate = False # 不让子logger日志向父logger传播
        logger.setLevel(logging.DEBUG)
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.DEBUG)
        formatter = logging.Formatter('%(asctime)s [%(levelname)s] - %(filename)s:%(lineno)s : %(message)s')
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)


def get_logger(name):
    logger = logging.getLogger(name)
    setup_logger_config(logger)

    return logger

def load_yaml_config(config_path):
    # with后面的求值对像必须要有一个enter()和exit()方法
    with open(config_path, "r") as file:
        config_data = yaml.load(file, yaml.SafeLoader)
    return config_data

def read_template(template_path):
    with open(template_path, "r") as file:
        template_data = file.read()
    return template_data

def generate_from_template_dict(template_data, map_table):
    generated_file = jinja2.Template(template_data).render(
        map_table
    )

    return generated_file
def write_generated_file(file_path, content_data):
    with open(file_path, "w+") as fout:
        fout.write(content_data)

def generate_template_file(template_file_path, output_path, map_table):
    template = read_template(template_file_path)
    generated_template = generate_from_template_dict(template, map_table)
    write_generated_file(output_path, generated_template)

def get_masters_workers_from_layout(layout):
    masters = list(filter(lambda elem: 'prophet-master' in elem and elem["prophet-master"] == 'true', layout['machine-list']))
    workers = list(filter(lambda elem: 'prophet-worker' in elem and elem["prophet-worker"] == 'true', layout['machine-list']))

    return masters, workers