pragma solidity ^0.4.25;
contract ContractWorkingWithMoney {
    
    uint investments;
    uint dividends;
    address owner;
    uint lastId;
    uint partOfInvestments;
    uint amountOfDividends;
    mapping (address => uint) paymentsMap;
    mapping (uint => address) indexMap;
    
    constructor () public {
        owner = tx.origin;
    }
    
    function () external payable {
        if (tx.origin == owner){
            dividends += msg.value;
            sendDividends();
        } else {
            investments += msg.value;
            addValueAndIndex(tx.origin, msg.value);
        }
    }
    
    function sendDividends () private {
        for (uint i = 0; i < lastId; i++) {
            address _adress = indexMap[i];
            partOfInvestments = investments * 1000000000000000000 / paymentsMap[_adress] ;
            amountOfDividends = dividends * 1000000000000000000 / partOfInvestments;
            _adress.transfer(amountOfDividends);
        }
        dividends = 0;
    }
    
    function addValueAndIndex (address _adress, uint _value) private {
        if(_adress != owner && paymentsMap[_adress] == 0) {
            indexMap[lastId++] = _adress;
        }
        paymentsMap[_adress] += _value;
    }
    
    function getValueByAdress (address _adress) external view returns(uint) {
        return (paymentsMap[_adress]);
    }
   
    function getBalanceInvestmentsDividends() external view returns(uint256, uint256, uint256){
        return (address(this).balance, investments, dividends);
    }
    
    function killContractAndGetMoney () external{
        selfdestruct(owner);
    }
    
    function getMoney () external{
        owner.transfer(investments);
    }
    
}