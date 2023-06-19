import argparse
import sys
from schema import Schema, Or, Optional, Regex
from utils import get_logger, load_yaml_config, get_master_workers_from_layout

def validate_layout_schema(layout):
    scehma = Schema(
        {
            'machine-sku': {
                str: {
                    'mem': str,
                    'cpu': {
                        'vcore': int,
                    },
                    Optional('computing-device'): {
                        'type': str,
                        'model': str,
                        'count': int,
                    }
                }
            },
            'machine-list': [
                {
                    'hostname': Regex(r"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"),
                    'hostip': Regex(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"),
                    'machine-type': str,
                    Optional('prophet-master'): Or('true', 'false'),
                    Optional('prophet-worker'): Or('true', 'false'),
                    Optional('prophet-storage'): Or('true', 'false'),
                }
            ]
        }
    )
    return scehma.validate(layout)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', '--layout', dest="layout", required=True,
                        help="layout.yaml")
    parser.add_argument('-c', '--config', dest="config", required=True,
                        help="cluster configuration")
    args = parser.parse_args()

    layout = load_yaml_config(args.layout)
    cluster_config = load_yaml_config(args.config)

    try:
        validate_layout_schema(layout)
    except Exception as exp:
        logger.error("layout.yaml schema validation failed: \n %s", exp)
        sys.exit(1)


if __name__ == "__main__": # 在这个底下的代码当import的时候，不会被执行
    main()