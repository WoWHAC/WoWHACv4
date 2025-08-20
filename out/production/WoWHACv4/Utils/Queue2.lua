Queue2 = class("Queue2")

function Queue2:init()
    self.data = {}
end

-- JS-подобный push: кладём в конец, срезаем до 2
function Queue2:push(value)
    table.insert(self.data, value)
    if #self.data > 2 then
        table.remove(self.data, 1) -- выкидываем старый
    end
end

-- JS-подобный pop: достаём последний
function Queue2:pop()
    return table.remove(self.data)
end

-- посмотреть первый (старший)
function Queue2:first()
    return self.data[1]
end

-- посмотреть второй (новый)
function Queue2:second()
    return self.data[2]
end

function Queue2:peek()
    return self.data[#self.data]
end

function Queue2:size()
    return #self.data
end

function Queue2:overwriteFirst(value)
    self.data[1] = value
end