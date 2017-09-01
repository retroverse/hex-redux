#Styles
require("../sass/Index")

#App
hex = require('./model/Model')
view = require('./view/View')
window.app = view(hex())
