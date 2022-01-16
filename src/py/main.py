# import tensorflow as tf
from nb_lib import cat, constants

from lib.constants import HELLO_CONSTANT

print(HELLO_CONSTANT)
print(constants.ANOTHER_CONSTANT)
# print(tf.__version__)

print(cat.Cat().hi())
print(cat.Cat().yell())
