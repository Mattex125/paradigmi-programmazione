// L05 - the same type, in C++.
//
//   g++ -std=c++20 -o expressions espressioni.cpp && ./expressions

#include <iostream>
#include <memory>
#include <string>
#include <variant>

struct Expr;
using P = Expr*;   // We don't use shared pointers on purpose.

// Four different types of nodes
struct Num { int n; };
struct Add { P a, b; };
struct Mul { P a, b; };
struct Neg { P a; };

// A container for any kind of node
struct Expr {
    std::variant<Num, Add, Mul, Neg> v;

    // A destructor must go here

};

// Node constructors
P num(int n)      { return new Expr{Num{n}}; }
P add(P a, P b)   { return new Expr{Add{a, b}}; }
P mul(P a, P b)   { return new Expr{Mul{a, b}}; }
P neg(P a)        { return new Expr{Neg{a}}; }

// An object that will include the appropriate functions to handle the
// different kind of nodes
template <class... F> struct cases : F... { using F::operator()...; };

int eval(const P& e) {
    return std::visit(cases{
        [](const Num& x) { return x.n; },
        [](const Add& x) { return eval(x.a) + eval(x.b); },
        [](const Mul& x) { return eval(x.a) * eval(x.b); },
        [](const Neg& x) { return -eval(x.a); },
        // NO default case. Try deleting a line and recompiling.
    }, e->v);
}

std::string show(const P& e) {
    return std::visit(cases{
        [](const Num& x) { return std::to_string(x.n); },
        [](const Add& x) { return "(" + show(x.a) + " + " + show(x.b) + ")"; },
        [](const Mul& x) { return "(" + show(x.a) + " * " + show(x.b) + ")"; },
        [](const Neg& x) { return "-" + show(x.a); },
    }, e->v);
}

int main() {
    P e1 = mul(add(num(2), num(3)), num(4));
    std::cout << show(e1) << " = " << eval(e1) << "\n";
    delete e1;
}
