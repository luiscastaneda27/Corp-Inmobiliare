// Takes a Number and returns a US/CAN currency string.
function toCurrency(amount) {
  return "$" + amount.toFixed(2);
};

// Adds a .toCurrency() method to Numbers.
Number.prototype.toCurrency = function() {
  return toCurrency(this);
};

console.log( (15.4).toCurrency() ); // "$15.40"