import re
from IPython.display import display, Markdown
class dis_Order:
    def __init__(self, inp):
        #parse input
        s = inp.find(' ') 

        self.operator_str = inp[:s]

        self.dist = inp[s+1:].split(',')[0]

        self.source = inp[s+1:].split(',')[1]

        #specify what is the oprand combination of order
        self.op_comb = self.order_ops_combination()

        print(self.op_comb)


        self.machine_code = {'prefix':'',
                             'rex':{'w':'0','r':'0','x':'0','b':'0'},
                             'opCode':'',
                             'W':'',
                             'mod':'',
                             'reg':'',
                             'R/M':'',
                             'scale':'',
                             'index':'',
                             'base':'',
                             'disp':'',
                             'data':''}

        self.machine_code['opCode'] = OpCode_filler(self.operator_str, self.op_comb)



        self.set_W_to_RM_2op()

        result = self.get_machine_code()
        print(result)
        display(Markdown(f"## **{result}**"))

        result = '0'*(result.find('1')//4) +str(hex(int(result, 2)))[2:]
        #result = hex(int(result, 2))


        display(Markdown(f"## **{result}**"))

    def get_machine_code(self):
        print(self.machine_code)

        codes = list(self.machine_code.values())

        rex = list(codes[1].values())


        rex = [''] if rex.count('1')==0 else ['0100']+rex


        codes = codes[0:1]+rex+codes[2:]

        return ''.join(codes)

    def order_ops_combination(self):
        def op_type(s):

            if(re.search("\[", s)): return 'mem'

            if(re.search("^\d+$|^0x\d+$", s)): return 'imm'
            return 'reg'
        source_type = op_type(self.source)

        dist_type = op_type(self.dist)

        return f'{dist_type}-{source_type}'

    def fill_machine_code(self):
        #set_opCode()
        #set_D_to_RM
        #set_SIB
        #set_rex
        #set_prefix
        pass

    def set_W_to_RM_2op(self):
        if(self.op_comb=='reg-reg'):
            self.fill_reg_reg()

        elif(self.op_comb=='mem-reg'):
            self.fill_mem_reg()

        elif(self.op_comb=='reg-mem'):
            self.fill_reg_mem()

        elif(self.op_comb=='imm-mem'):
            pass

        elif(self.op_comb=='imm-reg'):
            pass

        else:
            print('its not 2 operand order')
        
    def fill_reg_reg(self):
        source = Register(self.source)
        
        dist = Register(self.dist)

        
        self.machine_code['W'] = '0' if source.mode==8 else '1'
        
        self.machine_code['mod'] = '11'
        
        
        self.machine_code['R/M'] = dist.code[1:]
        
        self.machine_code['reg'] = source.code[1:]
        
        print('hiiii: source.mode-> ', source.mode)
        
        if(dist.code[0]=='1'): self.machine_code['rex']['b']='1'
        
        if(source.code[0]=='1'): self.machine_code['rex']['r']='1'
        
        if(source.mode==64): self.machine_code['rex']['w']='1'
        
        if(source.mode==16): self.machine_code['prefix'] = '01100110' #66
        
        
        
        #handle exceptions
        
        if(re.search('bsf|bsr|imul',self.operator_str)): #swap registers
            self.machine_code['R/M'],self.machine_code['reg'] = (
                self.machine_code['reg'],self.machine_code['R/M'])
            
            self.machine_code['rex']['r'],self.machine_code['rex']['b'] = (
            self.machine_code['rex']['b'],self.machine_code['rex']['r'])
            
        if(self.operator_str=='bsf'):self.machine_code['W']='0'
        
        if(self.operator_str=='bsr'): self.machine_code['W']='1'
            
    def fill_mem_reg(self):
        
        dist = Register(self.dist)
        
        self.machine_code['D'] = '1'
        
        self.machine_code['w'] = '0' if source.mode==8 else '1'
        
        self.machine_code['mod'] = '11'
        
        self.machine_code['R/M'] = dist.code
        
        self.machine_code['reg'] = source.code
        
        #fill...

    def fill_reg_mem(self):
        
        source = Register(self.source)
        
        self.machine_code['D'] = '0'
        
        self.machine_code['w'] = '0' if source.mode==8 else '1'
        
        self.machine_code['mod'] = '11'
        
        self.machine_code['R/M'] = dist.code
        
        self.machine_code['reg'] = source.code
        
        #fill...

   
        

        

class Dis_Register:
    def __init__(self, name):
        self.name = name
        self.code = self.register_code()
        self.mode = self.register_mode()
        self.is_new = (re.search("\d+", self.name)!=None)

    def register_code(self):
        reg = self.name
        #handle h registers
        if(reg=='0100'):
            return 'ah'

        if(reg=='0101'):
            return 'ch'

        if(reg=='0110'):
            return 'dh'

        if(reg=='0111'):
            return 'bh'

        if(reg[-2]=='0000'): 
            return 'a'

        if(reg[-2]=='0001'): 
            return 'c'

        if(reg[-2:]=='0010'):
            return ['dx','dl']

        if(reg[-2:]=='0011'):
            return ['bx','bl']

        if(reg[-2:]=='0100'):
            return 'sp'

        if(reg[-2:]=='0101'):
            return 'bp'

        if(reg[-2:]=='0110'):
            return 'si'

        if(reg[-2:]=='0111'):
            return 'di'

        return bin(int(re.search("\d+", reg)[0]))[2:]

    def register_mode(self):
        reg = self.name
        if(reg[0]=='r' and reg[-1]!='d' and reg[-1]!='w'): return 64
        if(reg[-1]=='d' or reg[0]=='e'): return 32
        if(reg[-1]=='w' or (len(reg)==2 and reg[-1]!='l' and reg[-1]!='h')):return 16
        return 8

#fill opCode section of machine code
def OpCode_filler(op,op_comb): #use op_comb and operator to get opCode

    if(op=='000000'):
        return 'add'
    
    if(op=='000100'):
        return 'adc'
    
    if(op=='001010'):
        return 'sub'
    
    if(op=='000110'):
        return 'sbb'
    
    if(op=='001000'):
        return 'and'

    if(op=='000010'):
        return 'or'

    if(op=='001100'):
        return 'xor'

    if(op=='001110'):
        return 'cmp'

    if(op=='100001'):
        return 'test'


    if(op=='100010'): 
        return 'mov'

    if(op=='1000011'): 
        return 'xchg'

    if(op=='000011111100000'):
       return 'xadd'

    if(op=='000011111010111'):
       return 'imul'

    if(op=='1111011'): 
        return 'idiv'

    if(op=='000011111011110'):  
        return 'bsf'

    if(op=='000011111011110'):  
        return 'bsr'
        

#order = Order(input())
