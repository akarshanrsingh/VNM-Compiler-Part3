# VNM Compiler — Part III: Abstract Syntax Tree Generation

**JavaCC & JJTree | Compiler Design | Java | Abstract Syntax Trees**

A compiler construction project focused on generating and refining **Abstract Syntax Trees (ASTs)** for VNM, a domain-specific programming language.
Developed as part of **CPS710 — Compilers** at **Toronto Metropolitan University**, this project extends lexical and syntax analysis by introducing structured syntax tree generation using JavaCC and JJTree.

## Project Overview

This project explores how a compiler transforms syntactically valid source code into a structured representation suitable for subsequent stages of interpretation or compilation.
The project builds upon the lexical analysis and parsing concepts introduced in Parts I and II. Part III uses a common parser provided as the starting point and focuses on modifying the JJTree grammar to produce meaningful abstract syntax trees.
The central objective is to transform detailed parse trees into simplified ASTs that preserve the semantic structure of expressions, statements, operators, and language constructs while eliminating unnecessary grammatical nodes.

### Key Objectives

- Generate syntax trees using JavaCC and JJTree.
- Represent VNM language constructs as AST nodes.
- Convert terminal tokens into meaningful leaf nodes.
- Remove redundant syntactic nodes from parse trees.
- Preserve operator precedence and associativity.
- Construct unary, binary, and n-ary operator trees.
- Represent conditional statements using consistent AST structures.
- Handle optional grammar components through explicit null nodes.
- Validate syntax tree generation using manual and automated tests.

## Technologies Used

- **Java** — Core implementation language and generated parser components.
- **JavaCC** — Lexical and syntax analysis.
- **JJTree** — Preprocessor for generating abstract syntax trees.
- **BNF / Context-Free Grammars** — Formal language specification.
- **GNU Make** — Automated build process.
- **Shell Scripts** — Program execution and automated testing.
- **Git & GitHub** — Version control and project documentation.

## Compiler Architecture

The project follows a structured processing pipeline:

**VNM Source Code → Lexical Analysis → Syntax Parsing → AST Construction → Syntax Tree Output**

### 1. Lexical Analysis

The lexical analyzer recognizes the tokens present in VNM source code, including identifiers, numeric constants, strings, Boolean values, operators, and delimiters.

### 2. Syntax Analysis

The JavaCC-generated parser validates token sequences against the VNM grammar and recognizes expressions and statements.

### 3. Abstract Syntax Tree Construction

JJTree extends the parser by creating AST nodes during grammar production processing.

Unlike a full parse tree, an AST focuses on meaningful program structure rather than every intermediate grammar production.

### 4. Syntax Tree Output

The generated tree can be inspected to understand the hierarchical representation of parsed expressions and statements.

The resulting AST structure is intended to support later compiler or interpreter development.

## JJTree Integration

The primary grammar specification is maintained in `VNM.jjt`.
JJTree processes this file and generates the corresponding JavaCC grammar and AST-related Java classes.

**Compilation Pipeline:**

`VNM.jjt → JJTree → VNM.jj → JavaCC → VNM.java → Java Compiler → VNM.class`

### JJTree Configuration

java
MULTI = true;
JJTREE_OUTPUT_DIRECTORY = "AST";
VISITOR = true;

- **`MULTI`** — Generates separate AST node classes for non-suppressed grammar productions.
- **`JJTREE_OUTPUT_DIRECTORY`** — Directs generated AST classes to the `AST` directory.
- **`VISITOR`** — Enables visitor-related code generation for subsequent compiler development.

The `SimpleNode` class provides the base implementation for AST nodes.

## Abstract Syntax Tree Design

The project focuses on creating concise, consistent, and meaningful AST structures.

### Terminal and Leaf Nodes

Tokens containing meaningful values are represented as AST leaf nodes, including:

- Numeric identifiers (`IDNUM`)
- Vector identifiers (`IDVEC`)
- Boolean identifiers (`IDBOOL`)
- Numeric constants (`NUMBER`)
- String constants (`STRING`)
- Boolean constants (`TRUE` and `FALSE`)
- Comparison operators

Value-carrying tokens require their associated values to be transferred into the corresponding AST nodes.

### Comparison Expressions

Comparison expressions are represented using an `ASTcomparison` node containing three children:

1. Left-hand expression
2. Comparison operator
3. Right-hand expression

Comparison operators are represented as individual AST nodes, such as `ASTLE` for the `<=` operator.

### Conditional Statements

Conditional statements use a consistent tree structure.

An `ASTIf` node contains three children:

- Condition
- Then clause
- Else clause

When an optional else clause is absent, an `ASTNULL` node represents the missing component.

`elif` constructs are represented internally through nested `ASTIf` nodes while preserving the original language syntax.

## Operator Representation

The AST design preserves operator precedence, associativity, and operand relationships through specialized node structures.

### Arithmetic Operations

**Multiplication, Division, and Modulo**

- **`ASTmul`** — Represents multiplication (`*`).
- **`ASTdiv`** — Represents division (`/`).
- **`ASTmod`** — Represents modulo (`%`).
- Each operator is represented by a binary AST node containing two operands.
- Consecutive operations follow left-associative evaluation, with earlier operations represented in the left subtree.

**Example:**

- **Expression:** `a * b / c`
- **AST representation:** `ASTdiv(ASTmul(a, b), c)`

**Addition and Subtraction**

- **`ASTsum`** — Represents additive expressions using an n-ary node.
- **`ASTpos`** — Identifies positively signed terms.
- **`ASTneg`** — Identifies negatively signed terms.
- The representation preserves the sign and ordering of individual terms within an expression.

**Example:**

- **Expression:** `a - b + c`
- **AST representation:** `ASTsum(a, ASTneg(b), ASTpos(c))`

### Boolean Operations

- **`ASTand`** — Represents logical AND (`&`) using an n-ary node.
- **`ASTor`** — Represents logical OR (`|`) using an n-ary node.
- **`ASTnot`** — Represents logical negation (`!`) using a unary node.

AND and OR expressions preserve operand ordering, while logical negation applies to a single operand.

## AST Optimization

A major focus of this project is removing unnecessary nodes from the syntax tree.

### Redundant Node Elimination

Grammar productions that only group other productions can be suppressed when they do not contribute meaningful information.

Examples include:

- `S`
- `statement_LL1`
- `statement`
- `identifier`
- `value`
- `term`
- `simple_term`

This produces a more concise AST while preserving the meaningful structure of the source program.

### List-Based AST Nodes

List structures are represented using n-ary nodes whose number of children corresponds to the number of parsed elements.

Relevant node types include:

- `ASTbody`
- `ASTclause`
- `ASTident_list`
- `ASTprint_list`
- `ASTexp_list`

Variable declaration nodes are also designed to contain identifier children directly rather than introducing unnecessary intermediate list nodes.

## Project Structure

The repository is organized into the following components:

### Grammar and Parser Implementation

- **`VNM.jjt`** — Primary JJTree grammar specification defining the VNM language productions and AST construction directives.
- **`VNM.java`** — JavaCC-generated parser responsible for processing and validating VNM source code.
- **`VNMConstants.java`** — Defines token constants used throughout the parsing process.
- **`VNMTokenManager.java`** — Manages lexical token recognition and processing.

### Abstract Syntax Tree Components

- **`AST/`** — Contains generated AST node classes and supporting tree structures.
- **`SimpleNode.java`** — Provides the base implementation for AST nodes, including node relationships and tree operations.

### Token Management and Error Handling

- **`Token.java`** — Defines the fundamental token representation used by the parser.
- **`ParseException.java`** — Handles syntax errors encountered during parsing.
- **`TokenMgrError.java`** — Reports lexical errors during token processing.

### Build and Execution

- **`makefile`** — Automates the JJTree, JavaCC, and Java compilation process.
- **`run`** — Launches the interactive parser and displays generated syntax trees.
- **`TestVNM.java`** — Provides the interface for testing the parser and inspecting AST output.

### Testing and Documentation

- **`Tests/`** — Contains test inputs and expected results for validating parser and AST behavior.
- **`runtests`** — Executes the automated test suite.
- **`t`** — Supports individual test execution.
- **`JJTree.pdf`** — Reference documentation covering JJTree concepts and syntax tree generation.
- **`README.md`** — Provides project documentation, technical details, and execution instructions.

Additional Java source files and generated support classes are included in the repository.

## Build and Execution

### Prerequisites

The project requires:

- Java Development Kit (JDK)
- JavaCC with JJTree
- GNU Make
- A Unix-compatible shell environment

The supplied Makefile was designed for the CPS710 course environment and may require configuration adjustments on other systems.

### Clone the Repository
bash
git clone https://github.com/akarshanrsingh/VNM-Compiler-Part3.git
cd VNM-Compiler-Part3

### Compile the Project
bash
make
The build process uses JJTree, JavaCC, and the Java compiler to generate the required parser and AST components.

### Run the Parser
Grant execution permission if necessary:
bash
chmod u+x run

Launch the interactive program:
bash
./run

Enter a valid VNM expression or statement to inspect its generated syntax tree.

**Example input:** `1+2*3;`

The resulting tree representation depends on the AST transformations implemented in `VNM.jjt`.

## Testing

The project provides scripts for manual and automated testing.

### Interactive Testing

Run:
bash
./run

Enter valid VNM expressions or statements and inspect the generated syntax trees.

### Automated Testing

Grant execution permissions:
bash
chmod u+x t runtests

Execute the test suite:
bash
./runtests

The testing scripts are intended to compare parser output against expected results.

### Parser Debugging

JavaCC supports parser tracing through the following option in `VNM.jjt`:
java
DEBUG_PARSER = true;

This can help investigate grammar processing and parsing behavior during development.

## Learning Outcomes

This project provides practical experience with:

- Compiler front-end architecture
- Grammar-directed syntax tree construction
- JavaCC and JJTree integration
- Abstract syntax tree design
- Terminal token conversion into AST leaves
- Operator precedence and associativity
- Unary, binary, and n-ary tree structures
- Conditional and list-based AST representations
- Parse tree simplification
- Automated compiler testing and debugging

## Academic Context

**Course:** CPS710 — Compilers  
**Institution:** Toronto Metropolitan University  
**Project:** VNM Interpreter — Part III: Syntax Tree Generation  
**Primary Language:** Java  
**Tools:** JavaCC, JJTree, GNU Make

The assignment uses a common parser supplied as the starting point for Part III. The development task focuses on refining `VNM.jjt` to construct the required AST structures.

### Related Repositories

- **Part I — Lexical Analysis:** https://github.com/akarshanrsingh/VNM-Compiler
- **Part II — Syntax Analysis:** https://github.com/akarshanrsingh/VNM-Compiler-Part2
- **Part III — Abstract Syntax Tree Generation:** https://github.com/akarshanrsingh/VNM-Compiler-Part3

## Author

**Akarshan R Singh**  
Computer Engineering  
Toronto Metropolitan University

## Project Scope

This repository documents the syntax tree generation stage of the CPS710 VNM Interpreter project. It focuses on representing language constructs through structured abstract syntax trees using JavaCC and JJTree.
The project is intended for academic learning and compiler development practice. It does not represent a complete production compiler or a full interpreter execution engine.
