defmodule Tree do
  defstruct [value: nil, left: nil, right: nil]
  
  def formulaToTree([head | []]), do: %Tree{value: head, right: nil, left: nil}
  def formulaToTree([head | tail]), do: 
    %Tree{value: head, right: nil, left: formulaToTree(tail)}

  # should return the result [:result => valid/invalid, %Tree{}=> answer]
  def solvingTree(tree), do: solvingTree(tree, tree, %Tree{}) 
   newResult = treeResult(solution, %Tree{value: current.value, left: nil, right: nil})
     

  def solvingTree(current, tree, solution) do
    # adds the current formula to the resolution tree
    newResult = treeResult(solution, %Tree{value: current.value, left: nil, right: nil})
    IO.inspect(current, label: "Atual")
    IO.inspect(tree, label: "Arvore")
    IO.inspect(newResult, label: "Novo resultado:")
    IO.puts("")
    IO.puts("") 
    cond do 
      closed?(current, newResult) ->  [:valid, newResult]
      Rules.hasOperator?(current.value) -> solvingTree(current.left, tree, Rules.addExpand(current, solution))   
      leaf?(current) -> [:invalid, solution]
      true ->  solvingTree(current.left, tree, newResult)
    end
  end
  

  def leaf?(tree) when is_atom(tree.value.formula), do: true
  def leaf?(%Tree{value: _, left: nil, right: nil}), do: true
  def leaf?(_), do: false

  ## it looks for any contradiction in the tree
  
  # base case: 
   def closed?(current, %Tree{value: v, left: nil, right: _}), do: contradiction?(current.value, v)
   def closed?(current, tree) do
    IO.puts("errou dentro do closed...")
    if contradiction?(current, tree) do 
      true
    else 
      IO.inspect(current)
      IO.inspect(tree.left)   
     closed?(current, tree.left)
    end
  end

  # extract the formula from both trees
  def contradiction?(%Tree{value: v1}, %Tree{value: v2}), do: contradiction?(v1, v2)
  def contradiction?(%Clauses{formula: f, sign: s1}, %Clauses{formula: f, sign: s2}) 
    when s1 != s2, do: true
  def contradiction?(_,_), do: false  


  # it updates the first result
  def treeResult(%Tree{value: nil, right: _, left: _}, newResult) do 
    #IO.inspect(tree, label: "folha")
    newResult
  end
  # reaches the leaf 
  def treeResult(%Tree{value: v, right: _, left: nil}, newResult) do 
    #IO.inspect(tree, label: "folha")
    %Tree{value: v, right: nil, left: newResult}
  end
  # traverse the tree
  def treeResult(%Tree{value: v, right: r, left: l}, newResult) do
    #IO.inspect(tree, label: "caule")
    %Tree{value: v, right: r, left: treeResult(l, newResult)}
  end

end
