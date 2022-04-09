local Calculadora = {}

local Mascaras = {
	[1] = { 127, 255, 255, 255 },
	[2] = { 63, 255, 255, 255 },
	[3] = { 31, 255, 255, 255 },
	[4] = { 15, 255, 255, 255 },
	[5] = { 7, 255, 255, 255 },
	[6] = { 3, 255, 255, 255 },
	[7] = { 1, 255, 255, 255 },
	[8] = { 0, 255, 255, 255 },
	[9] = { 0, 127, 255, 255 },
	[10] = { 0, 63, 255, 255 },
	[11] = { 0, 31, 255, 255 },
	[12] = { 0, 15, 255, 255 },
	[13] = { 0, 7, 255, 255 },
	[14] = { 0, 3, 255, 255 },
	[15] = { 0, 1, 255, 255 },
	[16] = { 0, 0, 255, 255 },
	[17] = { 0, 0, 127, 255 },
	[18] = { 0, 0, 63, 255 },
	[19] = { 0, 0, 31, 255 },
	[20] = { 0, 0, 15, 255 },
	[21] = { 0, 0, 7, 255 },
	[22] = { 0, 0, 3, 255 },
	[23] = { 0, 0, 1, 255 },
	[24] = { 0, 0, 0, 255 },
	[25] = { 0, 0, 0, 127 },
	[26] = { 0, 0, 0, 63 },
	[27] = { 0, 0, 0, 31 },
	[28] = { 0, 0, 0, 15 },
	[29] = { 0, 0, 0, 7 },
	[30] = { 0, 0, 0, 3 },
	[31] = { 0, 0, 0, 1 }
}

local subMasks = {
    ["A"] = "255.0.0.0",
    ["B"] = "255.255.0.0",
    ["C"] = "255.255.255.0",
    ["D"] = nil,
    ["E"] = nil
}

local function strSplit(inputStr, separador)
    local tbl = {}
    for v in string.gmatch(inputStr, "([^"..separador.."]+)") do
        tbl[#tbl + 1] = v
    end
    return tbl
end

local function strUnsplit(array, separador)
    local str = ""
    for i,v in pairs(array) do
        if i == #array then
            str = str..v
        else
            str = str..v..separador
        end
    end
    return str
end

function Calculadora.new(IP, Mascara)
    if not IP:find("(%d+).(%d+).(%d+).(%d+)") then
        error("IP inválido")
    end

    return setmetatable({
        IP = strSplit(IP, "."),
        Mascara = Mascara
    }, {
        __index = Calculadora
    })
end

function Calculadora:getIP()
    return  strUnsplit(self.IP, ".").."/"..self.Mascara
end

function Calculadora:getNetworkIP()
    local sub = Mascaras[self.Mascara]

    local networkIp = {}
    for i,v in pairs(self.IP) do
        if sub[i] == 0 then
            networkIp[i] = v
        elseif sub[i] == 255 then
            networkIp[i] = 0
        else
            networkIp[i] = v - (v % (sub[i] + 1 ))
        end
    end

    return strUnsplit(networkIp, ".")
end

function Calculadora:getBroadcast()
    local broadcast = ""
    local sub = Mascaras[self.Mascara]
    local networkIp = strSplit(self:getNetworkIP(), ".")

    for i,v in pairs(networkIp) do
        if i == #networkIp then
            broadcast = broadcast..(v + sub[i])
        else
            broadcast = broadcast..(v + sub[i]).."."
        end
    end

    return broadcast
end

function Calculadora:getRange()
    local IP = strSplit(self:getNetworkIP(), ".")
    local Broadcast = strSplit(self:getBroadcast(), ".")

    IP[4] = IP[4] + 1
    Broadcast[4] = Broadcast[4] - 1

    return strUnsplit(IP, ".").." - "..strUnsplit(Broadcast, ".")
end

function Calculadora:getClasse()
    local ip = tonumber(self.IP[1])

    if (ip >= 0 and ip <= 127) then
        return "A"
    elseif (ip >=128 and ip <= 191) then
        return "B"
    elseif (ip >= 192 and ip <= 223) then
        return "C"
    elseif (ip >= 224 and ip <= 239) then
        return "D"
    end

    return "E"
end

function Calculadora:getMascara()
    return subMasks[self:getClasse()]
end

local calc = Calculadora.new("192.168.102.54", 24)

print(
    "IP: "..calc:getIP().."\n"..
    "Endereço da rede: "..calc:getNetworkIP().."\n"..
    "Broadcast: "..calc:getBroadcast().."\n"..
    "Classe: "..calc:getClasse().."\n"..
    "Máscara da sub-rede: "..calc:getMascara().."\n"..
    "Range: "..calc:getRange()
)