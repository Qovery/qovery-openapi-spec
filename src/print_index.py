from os import listdir
from os.path import isfile, join


def index(dir):
  files = [f for f in listdir(dir) if isfile(join(".", f))]
  for f in files:
    stripped = f.replace(".yaml", "")
    print(stripped + ":")
    print(" $ref: ./" + f)


if __name__ == '__main__':
  index(".")
