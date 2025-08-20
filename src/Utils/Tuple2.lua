Tuple2 = class("Tuple2")

function Tuple2:init()
    self.first = nil
    self.second = nil
end

function Tuple2:GetFirst()
    return self.first
end

function Tuple2:GetSecond()
    return self.second
end

function Tuple2:SetFirst(value)
    self.first = value
end

function Tuple2:SetSecond(value)
    self.second = value
end