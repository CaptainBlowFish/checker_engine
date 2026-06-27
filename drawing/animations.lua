require("helperFunctions")

---@class baseAnimation base class for all animations
---@field image love.Image
---@field x number coordinate
---@field y number coordinate
---@field r number rotation in radians
---@field w number width of the image
---@field h number height of the image
---@field totalSteps integer number of steps in the animation before it stops
---@field selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@field init function initializes the animation
---@field progress function progresses the animation
baseAnimation = {}

---@param image love.Image
---@param x number coordinate
---@param y number coordinate
---@param r number rotation in radians
---@param w number width of the image
---@param h number height of the image
---@param totalSteps integer number of steps in the animation before it stops
---@param selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@return baseAnimation
function baseAnimation.init(image, x, y, r, w, h, totalSteps, selfDelete)
    self = table.deepCopy(baseAnimation)
    self.x = x
    self.y = y
    self.r = r
    self.w = w
    self.h = h
    self.image = image
    self.stepsTaken = 0
    self.totalSteps = totalSteps
    self.selfDelete = selfDelete
    return self
end

---@param steps integer | nil animation steps taken during this call
---@return boolean @ returns if the animation should be deleted
function baseAnimation:progress(steps)
    steps = steps or 1
    self.stepsTaken = self.stepsTaken + steps
    if self.stepsTaken > self.totalSteps then
        return self.selfDelete
    end
    return false
end

---Draws the animation in its current state
function baseAnimation:draw()
    love.graphics.draw(self.image, self.x, self.y, self.r, self.w, self.h)
end

---@type {[string]:baseAnimation}
animations = {}

---@class grow : baseAnimation grows an image in all directions equally
---@field dW number change in width per step
---@field dH number change in height per step
animations.grow = table.deepCopy(baseAnimation)

---@param image love.Image
---@param x number coordinate
---@param y number coordinate
---@param r number rotation in radians
---@param w number width of the image
---@param h number height of the image
---@param dW number change in width per step
---@param dH number change in height per step
---@param totalSteps integer number of steps in the animation before it stops
---@param selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@return grow
function animations.grow.init(image, x, y, r, w, h, dW, dH, totalSteps, selfDelete)
    ---@class grow
    self = baseAnimation.init(image, x, y, r, w, h, totalSteps, selfDelete)
    self.dW = dW
    self.dH = dH
    return self
end

---@param steps integer | nil animation steps taken during this call
---@return boolean @ returns if the animation should be deleted
function animations.grow:progress(steps)
    steps = steps or 1
    self.stepsTaken = self.stepsTaken + steps

    self.h = self.h + self.dH * steps
    self.w = self.w + self.dW * steps
    ---To keep the same center
    self.x = self.x - self.dW * steps / 2
    self.y = self.y - self.dH * steps / 2

    if self.stepsTaken > self.totalSteps then
        return self.selfDelete
    end
    return false
end
