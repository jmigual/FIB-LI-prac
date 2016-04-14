#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <iomanip>
#include <vector>
#include <chrono>
#include <set>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

typedef unsigned int uint;

uint numVars;
uint numClauses;
vector< vector<int> > clauses;  // Has the expressions
vector<short> model;            // Contains the current result
vector<int> modelStack;         // Contains the recursion and decisions
uint indexOfNextLitToPropagate; // Next index to be propagated
uint decisionLevel;             // DL

vector< int > literalPuntuation;
//vector< int > literalCounter;               // Counts how many times a litearl appears
vector< vector<int> > clausesLitPositive;   // Clauses where the literal is Positive
vector< vector<int> > clausesLitNegative;   // Clauses where the literal is Negative
long long totalPropagate = 0;
chrono::high_resolution_clock::time_point totalTime;

struct LitComparator {
  bool operator() (const int a, const int b) const {
    return literalPuntuation[a] > literalPuntuation[b];
  }
};
multiset< int, LitComparator > literalOrd;


void readClauses( ) {
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }
  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  clausesLitPositive.resize(numVars + 1);
  clausesLitNegative.resize(numVars + 1);
  //literalCounter.resize(numVars);
  literalPuntuation = vector<int> (numVars + 1, 0);
  
  //for (uint i = 0; i < numVars + 1; ++i) literalCounter[i] = i + 1;
  
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
    
      if (lit > 0) clausesLitPositive[lit].push_back(i);
      else clausesLitNegative[-lit].push_back(i);
      ++literalPuntuation[abs(lit)];
      
      clauses[i].push_back(lit);
    }
  }
  
  for (uint i = 0; i < numVars; ++i) {
    literalOrd.insert(i + 1);
  }
  
  //sort(literalCounter.begin(), literalCounter.end(), sortLiterals);
}

int currentValueInModel(int lit) {
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}

void setLiteralToTrue(int lit) {
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;
}

// Checks the selected clauses passed in the selected vector
bool checkClausulesForConflict ( vector<int> &selectedClauses) {
  for (uint i = 0; i < selectedClauses.size(); ++i) {
    int numClause = selectedClauses[i];
    
    bool someLitTrue = false;
    int numUndefs = 0;
    int lastLitUndef = 0;
    for (uint k = 0; not someLitTrue and k < clauses[numClause].size(); ++k) {
      int val = currentValueInModel(clauses[numClause][k]);
      if (val == TRUE) someLitTrue = true;
      else if (val == UNDEF) {
        ++numUndefs;
        lastLitUndef = clauses[numClause][k];
      }
    }
    if (not someLitTrue and numUndefs == 0) return true; // conflict! all lits false
    else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
  }
  return false;
}

bool propagateGivesConflict () {
  auto start = chrono::high_resolution_clock::now();
  bool ret = false;
  
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    int lit = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    
    // Checks only the clauses where the Literal is assigned false
    if (lit > 0 && checkClausulesForConflict(clausesLitNegative[lit])) {
      literalPuntuation[lit] -= 1;
      literalOrd.erase(lit);
      literalOrd.insert(lit);
      ret = true;
      break;
    } else if (lit < 0 && checkClausulesForConflict(clausesLitPositive[-lit])) {
      literalPuntuation[-lit] -= 1;
      literalOrd.erase(-lit);
      literalOrd.insert(-lit);
      ret = true;
      break;
    }
    
  }
  auto elapsed = chrono::high_resolution_clock::now() - start;
  totalPropagate += chrono::duration_cast<chrono::microseconds> (elapsed).count();
  return ret;
}

void backtrack() {
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0) { // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Heuristic for finding the next decision literal:
int getNextDecisionLiteral() {
  //sort(literalCounter.begin(), literalCounter.end(), sortLiterals);
  
  for (auto it = literalOrd.begin(); it != literalOrd.end(); ++it) {
    if (model[*it] == UNDEF) return *it;
  }
  /*
  for (uint i = 1; i <= numVars; ++i) {
    if (model[literalCounter[i]] == UNDEF) return literalCounter[i];
    //if (model[i] == UNDEF) return i;  // returns first UNDEF var, positively
  }*/
  return 0; // reurns 0 when all literals are defined
}

void checkmodel() {
  for (uint i = 0; i < numClauses; ++i) {
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j) {
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    }
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }
}

void showTimes() {
  cout.setf(ios::fixed);
  cout.precision(2);
  
  auto elapsed = chrono::high_resolution_clock::now() - totalTime;
  long long tTime = chrono::duration_cast<chrono::microseconds> (elapsed).count();
  cout << "Total Propagate: " << setw(6) << setfill('0') << totalPropagate/1000.0 << " ms "
       << totalPropagate/double(tTime) * 100.0 << "%" <<  endl;
  cout << "Total Time     : " << tTime/1000.0 << " ms" << endl;
}

int main() {
  totalTime = chrono::high_resolution_clock::now();
  
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars + 1,UNDEF);
  indexOfNextLitToPropagate = 0;
  decisionLevel = 0;
  
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i) {
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      
      int val = currentValueInModel(lit);
      if (val == FALSE) {
        cout << "UNSATISFIABLE" << endl;
        return 10;
      } else if (val == UNDEF) setLiteralToTrue(lit);
    }
  }
  
  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if (decisionLevel == 0) {
        showTimes();
        cout << "UNSATISFIABLE" << endl;
        return 10;
      }
      backtrack();
    }
    
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) {
      checkmodel();
      showTimes();
      cout << "SATISFIABLE" << endl;
      return 20;
    }
    
    // start new decision level:
    modelStack.push_back(0);          // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}

