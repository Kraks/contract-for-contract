pragma solidity ^0.8.9;

contract C {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error PreViolationAddr(uint256 specId);

    error PostViolationAddr(uint256 specId);

    /// @custom:consol {
    ///    f(a, b) returns c ensures { c > a + b }
    ///  }
    function f_original(uint256 a, uint256 b) private returns (uint256) {
        return a + b;
    }

    /// @custom:consol {
    ///    g(a, b) returns (c) ensures { c > a * b }
    ///  }
    function g_original(uint256 a, uint256 b) private returns (uint256) {
        return a * b;
    }

    /// @custom:consol {
    ///    h(a, b) returns (c, d) ensures { c + d == (a * b) + (a + b) }
    ///  }
    function h_original(uint256 a, uint256 b) private returns (uint256, uint256) {
        return (a * b, a + b);
    }

    /// @custom:consol {
    ///    p(a, b) returns (c, d, e) ensures { (c + d) * e == (a * b) + (a + b) }
    ///  }
    function p_original(uint256 a, uint256 b) private returns (uint256, uint256, uint256) {
        return (a * b, a + b, 1);
    }

    function _fPost(uint256 a, uint256 b, uint256 c) private {
        if (!(c>a+b)) revert postViolation("f");
    }

    function f(uint256 a, uint256 b) public returns (uint256) {
        uint256 c = f_original(a, b);
        _fPost(a, b, c);
        return (c);
    }

    function _gPost(uint256 a, uint256 b, uint256 c) private {
        if (!(c>a*b)) revert postViolation("g");
    }

    function g(uint256 a, uint256 b) public returns (uint256) {
        uint256 c = g_original(a, b);
        _gPost(a, b, c);
        return (c);
    }

    function _hPost(uint256 a, uint256 b, uint256 c, uint256 d) private {
        if (!(c+d==(a*b)+(a+b))) revert postViolation("h");
    }

    function h(uint256 a, uint256 b) public returns (uint256, uint256) {
        (uint256 c, uint256 d) = h_original(a, b);
        _hPost(a, b, c, d);
        return (c, d);
    }

    function _pPost(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e) private {
        if (!((c+d)*e==(a*b)+(a+b))) revert postViolation("p");
    }

    function p(uint256 a, uint256 b) public returns (uint256, uint256, uint256) {
        (uint256 c, uint256 d, uint256 e) = p_original(a, b);
        _pPost(a, b, c, d, e);
        return (c, d, e);
    }
}
