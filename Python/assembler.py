import re
#from IPython.display import display, Markdown
def fill_reg_reg(self):
    
    source = Register(self.source)
    
    dist = Register(self.dist)
    
    self.machine_code['W'] = '0' if source.mode==8 else '1'
    
    self.machine_code['mod'] = '11'
    
    self.machine_code['R/M'] = dist.code[1:]
    
    self.machine_code['reg'] = source.code[1:]
    
    if(dist.code[0]=='1'): 
        self.machine_code['rex']['b']='1'
    

    if(source.code[0]=='1'): 
        self.machine_code['rex']['r']='1'
    
    if(source.mode==64): 
        self.machine_code['rex']['w']='1'
    
    if(source.mode==16): 
        self.machine_code['prefix'] = '01100110' #66
            
    #handle exceptions
    if(re.search('bsf|bsr|imul',self.operator_str)): #swap registers
        self.machine_code['R/M'],self.machine_code['reg'] = (
            self.machine_code['reg'],self.machine_code['R/M'])
            
        self.machine_code['rex']['r'],self.machine_code['rex']['b'] = (
            self.machine_code['rex']['b'],self.machine_code['rex']['r'])
            
    if(self.operator_str=='bsf'):
        self.machine_code['W']='0'

    if(self.operator_str=='bsr'): 
        self.machine_code['W']='1'

class Order:
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
        #display(Markdown(f"## **{result}**"))
        
        result = '0'*(result.find('1')//4) +str(hex(int(result, 2)))[2:]
        #result = hex(int(result, 2))
        
        #display(Markdown(f"## **{result}**"))
        
        print(result)

    fill_reg_reg = fill_reg_reg

    def get_machine_code(self):
        
        print(self.machine_code)
        
        codes = list(self.machine_code.values())
        
        rex = list(codes[1].values())
        
        rex = [''] if rex.count('1')==0 else ['0100']+rex
        
        codes = codes[0:1]+rex+codes[2:]
        
        return ''.join(codes)

    def order_ops_combination(self):
        def op_type(s):
            if(re.search("\[", s)): 
                return 'mem'

            if(re.search("^\d+$|^0x\d+$", s)): 
                return 'imm'

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
        
    
            




    


   
        

        


class Register:
    def __init__(self, name):
        self.name = name

        
        self.code = self.register_code()
        
        self.mode = self.register_mode()
        
        self.is_new = (re.search("\d+", self.name)!=None)

    def register_code(self):
        
        reg = self.name
        #handle h registers
        
        if(reg=='ah'):
            return '0100'
        
        if(reg=='ch'):
            return '0101'
        
        if(reg=='dh'):
            return '0110'
        
        if(reg=='bh'):
            return '0111'

        if(reg[-2]=='a'):
            return '0000'
        
        if(reg[-2]=='c'):
            return '0001'
        
        if(reg[-2:]=='dx' or reg[-2:]=='dl'):
            return '0010'
        
        if(reg[-2:]=='bx' or reg[-2:]=='bl'):
            return '0011'
        
        if(reg[-2:]=='sp'):
            return '0100'
        
        if(reg[-2:]=='bp'):
            return '0101'
        
        if(reg[-2:]=='si'):
            return '0110'
        
        if(reg[-2:]=='di'):
            return '0111'

        return bin(int(re.search("\d+", reg)[0]))[2:]

    def register_mode(self):
        reg = self.name

        if(reg[0]=='r' and reg[-1]!='d' and reg[-1]!='w'):
            return 64
        
        if(reg[-1]=='d' or reg[0]=='e'):
            return 32
        
        if(reg[-1]=='w' or (len(reg)==2 and reg[-1]!='l' and reg[-1]!='h')):return 16
        
        return 8

#fill opCode section of machine code
def OpCode_filler(op,op_comb): #use op_comb and operator to get opCode
    check = (op_comb=='imm-reg' or op_comb=='imm-mem')
    check2 = (op_comb=='mem-reg')
    if(op=='add'): 
        return ['100000s','000'] if check else '000000'+str(int(check2))
    
    if(op=='adc'): 
        return ['100000s','010'] if check else '000100'+str(int(check2))
    
    if(op=='sub'): 
        return ['100000s','101'] if check else '001010'+str(int(check2))
    
    if(op=='sbb'): 
        return ['100000s','011'] if check else '000110'+str(int(check2))
    
    if(op=='and'): 
        return ['100000s','100'] if check else '001000'+str(int(check2))
    
    if(op=='or') : 
        return ['100000s','001'] if check else '000010'+str(int(check2))
    
    if(op=='xor'): 
        return ['100000s','110'] if check else '001100'+str(int(check2))
    
    if(op=='cmp'): 
        return ['100000s','111'] if check else '001110'+str(int(check2))
    
    if(op=='test'):
        return ['111101s','000'] if check else '100001'+str(int(check2))

    if(op=='mov'): 
        
        if(not check):
            return '100010'+str(int(check2))
        
        if(op_comb=='imm-reg'):
            return '1011'
        
        return ['1100011','000']

    if(op=='xchg'):
        return '1000011'

    if(op=='xadd'):
        return '000011111100000'

    if(op=='imul'):
        return '000011111010111'

    if(op=='idiv'):
        return '1111011'

    if(op=='bsf'):
        return '000011111011110'

    if(op=='bsr'):
        return '000011111011110'


        
    #fill next single operand operators...

order = Order(input())



#define all filler functions here
