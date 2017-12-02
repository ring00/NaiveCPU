from network import Network
from utils import LOG_INFO
from layers import Relu, Sigmoid, Linear, ShortLinear
from loss import EuclideanLoss, SoftmaxCrossEntropyLoss
from solve_net import train_net, test_net
from load_data import load_mnist_2d
import numpy as np


train_data, test_data, train_label, test_label = load_mnist_2d('data')
model = Network()
model.add(Linear('fc1', 784, 10, 0.01))

loss = SoftmaxCrossEntropyLoss(name='xent')

config = {
    'learning_rate': 0.01,
    'weight_decay': 0.0005,
    'momentum': 0.9,
    'batch_size': 100,
    'max_epoch': 10,
    'disp_freq': 50,
    'test_epoch': 1
}


for epoch in range(config['max_epoch']):
    LOG_INFO('Training @ %d epoch...' % (epoch))
    train_net(model, loss, config, train_data, train_label, config['batch_size'], config['disp_freq'])
    LOG_INFO('Testing @ %d epoch...' % (epoch))
    test_net(model, loss, test_data, test_label, config['batch_size'])

W = model.layer_list[0].W

short_model = Network()
short_model.add(ShortLinear('short_fc1', np.around(W * 1000).astype(np.int16)))
test_net(short_model, loss, test_data, test_label, config['batch_size'])

np.savetxt('weights.txt', short_model.layer_list[0].W.T, fmt='%d')
