require("helperFunctions")

---@class baseAnimation base class for all animations
---@field image love.Image | love.Text
---@field x number coordinate
---@field y number coordinate
---@field r number rotation in radians
---@field w number width of the image
---@field h number height of the image
---@field totalSteps number number of steps in the animation before it stops
---@field selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
baseAnimation = {}

---@param image love.Image | love.Text
---@param x number coordinate
---@param y number coordinate
---@param r number | nil rotation in radians
---@param w number | nil width of the image
---@param h number | nil height of the image
---@param totalSteps number number of steps in the animation before it stops
---@param selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@return baseAnimation
function baseAnimation.init(image, x, y, r, w, h, totalSteps, selfDelete)
    local self = table.deepCopy(baseAnimation)
    self.x = x
    self.y = y
    self.r = r or 0
    self.w = w or image:getWidth()
    self.h = h or image:getHeight()
    self.image = image
    self.stepsTaken = 0
    self.totalSteps = totalSteps
    self.selfDelete = selfDelete
    return self
end

---@param steps number | nil animation steps taken during this call
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

---Resizes the animation based on the given scale
---@param w number
---@param h number
function baseAnimation:scale(w, h)
    self.w = self.w * w
    self.h = self.h * h
end

---@type {[string]:baseAnimation}
animations = {}

---@class grow : baseAnimation grows an image in all directions equally
---@field dW number change in width per step
---@field dH number change in height per step
animations.grow = table.deepCopy(baseAnimation)

---@param image love.Image | love.Text
---@param x number coordinate
---@param y number coordinate
---@param r number | nil rotation in radians
---@param w number | nil width of the image
---@param h number | nil height of the image
---@param dW number change in width per step
---@param dH number change in height per step
---@param totalSteps number number of steps in the animation before it stops
---@param selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@return grow
function animations.grow.init(image, x, y, r, w, h, dW, dH, totalSteps, selfDelete)
    ---@class grow
    local self = table.deepCopy(animations.grow)
    self.x = x
    self.y = y
    self.r = r or 0
    self.w = w or image:getWidth()
    self.h = h or image:getHeight()
    self.image = image
    self.stepsTaken = 0
    self.totalSteps = totalSteps
    self.selfDelete = selfDelete
    self.dW = dW
    self.dH = dH
    return self
end

---@param steps number | nil animation steps taken during this call
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

---@class move : baseAnimation grows an image in all directions equally
---@field destinationX number destination x coordinate
---@field destinationY number destination y coordinate
---@field stepX number ammount that the x coordinate changes per step
---@field stepY number ammount that the y coordinate changes per step
animations.move = table.deepCopy(baseAnimation)

---@param image love.Image | love.Text
---@param x number coordinate
---@param y number coordinate
---@param r number | nil rotation in radians
---@param w number | nil width of the image
---@param h number | nil height of the image
---@param destinationX number destination x coordinate
---@param destinationY number destination y coordinate
---@param totalSteps number number of steps in the animation before it stops
---@param selfDelete boolean controls wether the animation deletes itself after stepsTaken > totalSteps
---@return grow
function animations.move.init(image, x, y, r, w, h, destinationX, destinationY, totalSteps, selfDelete)
    ---@class grow
    local self = table.deepCopy(animations.grow)
    self.x = x
    self.y = y
    self.r = r or 0
    self.w = w or image:getWidth()
    self.h = h or image:getHeight()
    self.image = image
    self.stepsTaken = 0
    self.totalSteps = totalSteps
    self.selfDelete = selfDelete
    self.destinationX = destinationX
    self.destinationY = destinationY
    self.stepX = (destinationX - x) / totalSteps
    self.stepY = (destinationY - y) / totalSteps
    return self
end

---@param steps number | nil animation steps taken during this call
---@return boolean @ returns if the animation should be deleted
function animations.move:progress(steps)
    steps = steps or 1
    self.x = self.x + self.stepX
    self.y = self.y + self.stepY

    if self.stepsTaken > self.totalSteps then
        return self.selfDelete
    end
    return false
end
