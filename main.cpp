#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
#include <chrono>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;   // Has the expressions
vector<int> model;              // Contains the current result
vector<int> modelStack;         // Contains the recursion and decisions
uint indexOfNextLitToPropagate; // Next index to be propagated
uint decisionLevel;             // DL

vector< vector<int> > clausesLitPositive;
vector< vector<int> > clausesLitNegative;
long long totalPropagate = 0;
chrono::high_resolution_clock::time_point totalTime;


void readClauses( ){
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
  
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) 
    {
      
      if (lit > 0) clausesLitPositive[lit].push_back(i);
      else clausesLitNegative[-lit].push_back(i);
      
      clauses[i].push_back(lit);
    }
  }
}



int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;
}


bool checkClausules ( vector< vector<int> > &clausesLit, int lit) 
{
  int alit = abs(lit);
  for (uint i = 0; i < clausesLit[alit].size(); ++i)
  {
    int numClause = clausesLit[alit][i];
    
    bool someLitTrue = false;
    int numUndefs = 0;
    int lastLitUndef = 0;
    for (uint k = 0; not someLitTrue and k < clauses[numClause].size(); ++k)
    {
      int val = currentValueInModel(clauses[numClause][k]);
      if (val == TRUE) someLitTrue = true;
      else if (val == UNDEF)
      {
        ++numUndefs; lastLitUndef = clauses[numClause][k];
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
  
  while ( indexOfNextLitToPropagate < modelStack.size() )
  {
    int lit = modelStack[indexOfNextLitToPropagate];
    ++indexOfNextLitToPropagate;
    
    if (checkClausules(clausesLitNegative, lit)) {
      ret = true;
      break;
    }
    if (lit < 0 && checkClausules(clausesLitPositive, lit)) {
      ret = true;
      break;
    }
    
  }
  auto elapsed = chrono::high_resolution_clock::now() - start;
  totalPropagate += chrono::duration_cast<chrono::microseconds> (elapsed).count();
  return ret;
}


void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0) // 0 is the DL mark
  {
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
int getNextDecisionLiteral(){
  // stupid heuristic:
  for (uint i = 1; i <= numVars; ++i)
  {
    if (model[i] == UNDEF) return i;  // returns first UNDEF var, positively
  }
  return 0; // reurns 0 when all literals are defined
}

void checkmodel(){
  for (uint i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j) 
    {
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
  auto elapsed = chrono::high_resolution_clock::now() - totalTime;
  long long tTime = chrono::duration_cast<chrono::microseconds> (elapsed).count();
  cout << "Total Propagate: " << totalPropagate/double(tTime) * 100.0 << " " << totalPropagate << endl;
  cout << "Total Time     : " << tTime << endl;
}

int main(){
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars + 1,UNDEF);
  indexOfNextLitToPropagate = 0;
  decisionLevel = 0;
  
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i) 
  {
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      
      int val = currentValueInModel(lit);
      if (val == FALSE) 
      {
        cout << "UNSATISFIABLE" << endl; 
        return 10;
      }
      else if (val == UNDEF) setLiteralToTrue(lit);
    }
  }
  
  totalTime = chrono::high_resolution_clock::now();
  
  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) 
    {
      if (decisionLevel == 0) 
      { 
        showTimes();
        cout << "UNSATISFIABLE" << endl; 
        return 10; 
      }
      backtrack();
    }
    
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0)
    {
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
