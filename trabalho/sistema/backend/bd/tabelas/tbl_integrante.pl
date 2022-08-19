created(1660939165.3686342).
assert(integrante(5,"teste","sads","cTqhGuB74rVAXc6",1,1,"d@hotmail.com")).
assert(integrante(6,"teste12321","abcd","cTqhGuB74rVAXc6",1,1,"email@hotmail.com")).
assert(integrante(4,"testeok","asdas","cTqhGuB74rVAXc6",1,1,"d@hotmail.com")).
retract(integrante(5,"teste","sads","cTqhGuB74rVAXc6",1,1,"d@hotmail.com")).
assert(integrante(5,"teste123","sads","cTqhGuB74rVAXc6",1,1,"d@hotmail.com")).
retract(integrante(5,"teste123","sads","cTqhGuB74rVAXc6",1,1,"d@hotmail.com")).
assert(integrante(5,"teste123","sads","senha123",1,1,"d@hotmail.com")).
