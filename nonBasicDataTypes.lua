require("helperFunctions")

---various data types
--#region
---tree
---@class treeNode
---@field data any
---@field weight number
---@field children treeNode[]
treeNode = {}

---initializes a tree
---@param data any
---@param weight number | nil
---@return treeNode
function treeNode.init(data, weight)
    local self = table.deepCopy(treeNode)
    self.data = data
    self.weight = weight or 0
    self.children = {}
    return self
end

---returns a list of all the data contained in the tree
---@param listOfData table | nil
---@return table
function treeNode:traverseData(listOfData)
    listOfData = listOfData or {}
    table.insert(listOfData, self.data)
    for _, value in pairs(self.children) do
        listOfData = value:traverseData(listOfData)
    end
    return listOfData
end

---returns a list of all the weights contained in the tree
---@param listOfWeights number[] | nil
---@return number[]
function treeNode:traverseWeights(listOfWeights)
    listOfWeights = listOfWeights or {}
    table.insert(listOfWeights, self.weight)
    for _, value in pairs(self.children) do
        listOfWeights = value:traverseData(listOfWeights)
    end

    return listOfWeights
end

---get the total of all wight associated with the tree
---@return number @total of all the weights contained in the the tree
function treeNode:sumWeights()
    local sum = self.weight
    for _, value in pairs(self.children) do
        sum = sum + value:sumWeights()
    end
    return sum
end

--#endregion

---t = treeNode.init(1)
---for i = 2, 5, 1 do
---    local child = treeNode.init(i)
---    for j = 1, 5, 1 do
---        table.insert(child.children, treeNode.init(j + 5 * i))
---    end
---    table.insert(t.children, child)
---end
---
---ts = table.tostring(t:traverse())
---print(ts)
