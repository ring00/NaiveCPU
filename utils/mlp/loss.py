from __future__ import division
import numpy as np


class EuclideanLoss(object):
    def __init__(self, name):
        self.name = name

    def forward(self, input, target):
        return 0.5 * np.mean(np.sum(np.square(input - target), axis=1))

    def backward(self, input, target):
        return (input - target) / len(input)

class SoftmaxCrossEntropyLoss(object):
    def __init__(self, name):
        self.name = name
        self.predict = None

    def forward(self, input, target):
        # numerical stable way of computing Softmax
        x = np.exp(input - input.max(axis=1, keepdims=True))
        self.predict = x / x.sum(axis=1, keepdims=True)
        return -np.sum(target * np.log(self.predict)) / len(input)

    def backward(self, input, target):
        return (self.predict - target) / len(input)