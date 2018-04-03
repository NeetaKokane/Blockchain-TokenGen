pragma solidity ^0.4.18; /* Solidity version*/

contract Admin{
address public admin; /* Public member which is having address datatype*/
}
contract TokenGen is Admin{
mapping (address=>uint) balanceOf; /* To map balanceOf  variable as a key(address)-value(uint) pair*/
/* Public Member variables*/
string public standard;
string public tokenName;
string public tokenSymbol;
uint8 public  tokDecimal;
uint256 public totalSupply;
uint256 public buyCost;
uint256 public sellCost;
/* Even to log details so that program can be debug in detail*/	
event Transfer(address _sender,address _rec,uint amount);
/* Modifier to be defined , to later use as a condition on specific function*/	
modifieronlyAdmin{
	require(msg.sender==admin); /* Sender has to be admin*/
	    _;
		  }
/* Function will generate token inorder to buy and sell tokens*/	
function TokenGen(string  _standard,string _name,string _symbol, uint8 _decimal, uint256 _totalSupply) public {
	standard=_standard;
	tokenName =_name;
	tokenSymbol =_symbol;
	tokDecimal=_decimal;
	totalSupply=_totalSupply;
	balanceOf[this] = totalSupply; 
	admin = msg.sender; /* account who execute this smart contract will become Admin*/
	}
	/* Function to retrieve current balance of input address*/
	functiongetBalance(address _address) public view returns(uint256) {
	returnbalanceOf[_address];
	}
	/* Only admin can set buyCost and sellCost of Token*/
functionsetCosts(uint _buy,uint _sell) public onlyAdmin{
buyCost= _buy;
sellCost=_sell;
    }
	/* Function to buy token and pay in ethers*/
functionbuyToken() public payable returns(bool) {
uint amount = (msg.value/(1 ether))/buyCost; //To convert in ethers
require(balanceOf[this]>=amount);
balanceOf[this]-=amount;
balanceOf[msg.sender]+=amount;
Transfer(this,msg.sender,amount);
return true;
    }
	/* Function to sell token and retrieve in ethers*/
functionsellToken(uint _noTokens) public{
require(balanceOf[msg.sender]>=_noTokens);
uint ether_amount = _noTokens *sellCost;
balanceOf[msg.sender]-=_noTokens;
balanceOf[this]+=_noTokens;	
/* To convert in ethers*/
if(!msg.sender.send((_noTokens*sellCost)*(1 ether))) {
			revert();
		}
		else{
			Transfer(msg.sender,this,_noTokens);
		}

    } 
}
