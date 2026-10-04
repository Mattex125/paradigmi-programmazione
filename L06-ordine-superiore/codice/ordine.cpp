// L06 - the same ideas in C++, and a choice the language forces you to
// write down.
//
//   g++ -std=c++23 -o higher_order ordine.cpp && ./higher_order

#include <algorithm>
#include <functional>
#include <iostream>
#include <numeric>
#include <ranges>
#include <vector>

// --------------------------------------------------------------------
// 1. A function that returns a function.

auto times(int k) {
    return [k](int n) { return n * k; };
}

// --------------------------------------------------------------------
// 2. Capture: in C++ you write it, and there are two different things.

void captures() {
    int k = 2;
    auto by_value     = [k](int n)  { return n * k; };   // copies k
    auto by_reference = [&k](int n) { return n * k; };   // refers to k

    k = 3;

    std::cout << "by_value(5)     = " << by_value(5)     << "\n";
    std::cout << "by_reference(5) = " << by_reference(5) << "\n";

    // by_value(5) is 10: k was copied when the lambda was born.
    //   -> it is a closure in the OCaml sense, and by_value(5) can be
    //      replaced by 10 anywhere.
    //
    // by_reference(5) is 15: the lambda refers to the variable, and the
    //   variable has changed.
    //   -> it is the exact equivalent of Python's [12, 12, 12].
    //
    // And it gets worse. If the lambda outlives the variable:
    //
    //     std::function<int(int)> factory() {
    //         int k = 2;
    //         return [&k](int n) { return n * k; };   // k dies here
    //     }
    //
    // the reference dangles and the program has undefined behaviour.
    //
    // Verified with g++ 16.2, -Wall -Wextra: NO WARNING. It compiles in
    // silence. The dangerous choice is one character, the &, and no tool
    // that is on by default will tell you.
}

// Three languages, three answers to the same question:
//   Python  does not let you choose, and gives you the surprising one
//   C++     forces you to choose, and the wrong choice is undefined
//   OCaml   the question does not arise: a binding never changes

// --------------------------------------------------------------------
// 3. map, filter, fold.

void map_filter_fold() {
    std::vector<int> l = {1, 2, 3, 4, 5};

    auto evens_times_ten = l
        | std::views::filter([](int n) { return n % 2 == 0; })
        | std::views::transform([](int n) { return n * 10; });

    int total = std::ranges::fold_left(evens_times_ten, 0, std::plus<>{});
    std::cout << "sum of the even numbers times ten = " << total << "\n";

    // A note on the history of the library: fold_left has had that name
    // only since C++23. Before, there was std::accumulate, in <numeric>,
    // and nobody called it a fold. The function had always been there;
    // the NAME arrived when the idea was recognised for what it is.
    int same_thing = std::accumulate(evens_times_ten.begin(),
                                     evens_times_ten.end(), 0);
    std::cout << "with accumulate                   = " << same_thing << "\n";
}

// --------------------------------------------------------------------
// 4. Composition and currying.

void composition() {
    auto times_five = [](int n) { return n * 5; };
    auto minus_one  = [](int n) { return n - 1; };
    auto composed   = [=](int n) { return minus_one(times_five(n)); };
    std::cout << "composed(4) = " << composed(4) << "\n";

    // In OCaml composition is an ordinary function:
    //     let ( %> ) g f x = f (g x)
    // In C++ it is not in the library and everybody rewrites it. That is
    // not a serious shortcoming: in a language where functions were not
    // first-class values from the start, composing is not a frequent
    // enough gesture to deserve a name in the library.

    std::cout << "double(5) = " << times(2)(5) << "\n";
    // times(2)(5) is, in OCaml,  times 2 5.
    // Currying is there; it is the syntax that makes it visible or not.
}

int main() {
    captures();
    map_filter_fold();
    composition();
}
