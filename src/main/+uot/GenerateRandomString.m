function res = GenerateRandomString(string_length)
     symbols = ['a':'z' 'A':'Z' '0':'9'];
     nums = randi(numel(symbols),[1 string_length]);
     res = symbols (nums);
end