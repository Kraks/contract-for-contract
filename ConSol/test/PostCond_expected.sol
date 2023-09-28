pragma solidity ^0.8.9;

contract C {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    /// @custom:consol {
    ///    f(a, b) returns c1 ensures { c1 > a + b }
    ///  }
    function f_original(uint256 a, uint256 b) private returns (uint256) {
        return a + b;
    }

    /// @custom:consol {
    ///    g(a, b) returns (c2) ensures { c2 > a * b }
    ///  }
    function g_original(uint256 a, uint256 b) private returns (uint256) {
        return a * b;
    }

    /// @custom:consol {
    ///    h(a, b) returns (c3, d) ensures { c3 + d == (a * b) + (a + b) }
    ///  }
    function h_original(uint256 a, uint256 b) private returns (uint256, uint256) {
        return (a * b, a + b);
    }

    /// @custom:consol {
    ///    p(a, b) returns (c4, d, e) ensures { (c4 + d) * e == (a * b) + (a + b) }
    ///  }
    function p_original(uint256 a, uint256 b) private returns (uint256, uint256, uint256) {
        return (a * b, a + b, 1);
    }

    function _f_post(uint256 a, uint256 b, uint256 c1) private {
        if (!(c1>a+b)) revert postViolation("f");
    }

    function f(uint256 a, uint256 b) public returns (uint256) {
        uint256 c1 = f_original(a, b);
        _f_post(a, b, c1);
        return (c1);
    }

    function _g_post(uint256 a, uint256 b, uint256 c2) private {
        if (!(c2>a*b)) revert postViolation("g");
    }

    function g(uint256 a, uint256 b) public returns (uint256) {
        uint256 c2 = g_original(a, b);
        _g_post(a, b, c2);
        return (c2);
    }

    function _h_post(uint256 a, uint256 b, uint256 c3, uint256 d) private {
        if (!(c3+d==(a*b)+(a+b))) revert postViolation("h");
    }

    function h(uint256 a, uint256 b) public returns (uint256, uint256) {
        (uint256 c3, uint256 d) = h_original(a, b);
        _h_post(a, b, c3, d);
        return (c3, d);
    }

    function _p_post(uint256 a, uint256 b, uint256 c4, uint256 d, uint256 e) private {
        if (!((c4+d)*e==(a*b)+(a+b))) revert postViolation("p");
    }

    function p(uint256 a, uint256 b) public returns (uint256, uint256, uint256) {
        (uint256 c4, uint256 d, uint256 e) = p_original(a, b);
        _p_post(a, b, c4, d, e);
        return (c4, d, e);
    }
}