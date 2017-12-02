import numpy as np


class Layer(object):
    def __init__(self, name, trainable=False):
        self.name = name
        self.trainable = trainable
        self._saved_tensor = None

    def forward(self, input):
        pass

    def backward(self, grad_output):
        pass

    def update(self, config):
        pass

    def _saved_for_backward(self, tensor):
        self._saved_tensor = tensor


class Relu(Layer):
    def __init__(self, name):
        super(Relu, self).__init__(name)

    def forward(self, input):
        self._saved_for_backward(input)
        return np.maximum(0, input)

    def backward(self, grad_output):
        input = self._saved_tensor
        return grad_output * (input > 0)


class Sigmoid(Layer):
    def __init__(self, name):
        super(Sigmoid, self).__init__(name)

    def forward(self, input):
        output = 1 / (1 + np.exp(-input))
        self._saved_for_backward(output)
        return output

    def backward(self, grad_output):
        output = self._saved_tensor
        return grad_output * output * (1 - output)


class Linear(Layer):
    def __init__(self, name, in_num, out_num, init_std):
        super(Linear, self).__init__(name, trainable=True)
        self.in_num = in_num
        self.out_num = out_num
        self.W = np.random.randn(in_num, out_num) * init_std

        self.grad_W = np.zeros((in_num, out_num))

        self.diff_W = np.zeros((in_num, out_num))

    def forward(self, input):
        self._saved_for_backward(input)
        output = np.dot(input, self.W)
        return output

    def backward(self, grad_output):
        input = self._saved_tensor
        self.grad_W = np.dot(input.T, grad_output)
        return np.dot(grad_output, self.W.T)

    def update(self, config):
        mm = config['momentum']
        lr = config['learning_rate']
        wd = config['weight_decay']

        self.diff_W = mm * self.diff_W + (self.grad_W + wd * self.W)
        self.W = self.W - lr * self.diff_W

class ShortLinear(Layer):
    def __init__(self, name, weights, trainable=False):
        self.name = name
        self.trainable = trainable
        self.W = weights

    def forward(self, input):
        return np.dot(input.astype(np.int16), self.W)
