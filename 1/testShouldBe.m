function testShouldBe( computedValue, expectedValue )
%TESTSHOULDBE Summary of this function goes here
%   Detailed explanation goes here
    isEql = (computedValue == expectedValue);
    if isEql == 1,
     disp('test successfully passed');
    else
     disp(['computed value is ', num2str(computedValue), ' but ', num2str(expectedValue), ' was expected.'])
    end
    disp('');
    
end

