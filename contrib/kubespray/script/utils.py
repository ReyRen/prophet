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


def get_logger(name):
    logger = logging.getLogger(name)
    setup_logger_config(logger)

    return logger

def load_yaml_config(config_path):
    # with后面的求值对像必须要有一个enter()和exit()方法
    with open(config_path, "r") as file:
        config_data = yaml.load(file, yaml.SafeLoader)
    return config_data