
charToInts = {}

intsToChar={}
answerTypes={}
answerTypes["NOTHING"]="nothing"
answerTypes["ACTION_DONE"]="done"

function initCommunication()
	intsToChar = {
		{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'},
		{'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' ', '!', '.', '?'},
		{'#', '+', '-', '*', '/', '$', '{', '}', ':','\t','\n', '=', '[', ']', '"'},
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'},
		{'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '(', ')', '_', ','},
		{'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
	}
	charToInts['a']={1,1}
	charToInts['b']={1,2}
	charToInts['c']={1,3}
	charToInts['d']={1,4}
	charToInts['e']={1,5}
	charToInts['f']={1,6}
	charToInts['g']={1,7}
	charToInts['h']={1,8}
	charToInts['i']={1,9}
	charToInts['j']={1,10}
	charToInts['k']={1,11}
	charToInts['l']={1,12}
	charToInts['m']={1,13}
	charToInts['n']={1,14}
	charToInts['o']={1,15}
	charToInts['p']={2,1}
	charToInts['q']={2,2}
	charToInts['r']={2,3}
	charToInts['s']={2,4}
	charToInts['t']={2,5}
	charToInts['u']={2,6}
	charToInts['v']={2,7}
	charToInts['w']={2,8}
	charToInts['x']={2,9}
	charToInts['y']={2,10}
	charToInts['z']={2,11}
	charToInts[' ']={2,12}
	charToInts['!']={2,13}
	charToInts['.']={2,14}
	charToInts['?']={2,15}
	charToInts['#']={3,1}
	charToInts['+']={3,2}
	charToInts['-']={3,3}
	charToInts['*']={3,4}
	charToInts['/']={3,5}
	charToInts['$']={3,6}
	charToInts['{']={3,7}
	charToInts['}']={3,8}
	charToInts[':']={3,9}
	charToInts['\t']={3,10}
	charToInts['\n']={3,11}
	charToInts['=']={3,12}
	charToInts['[']={3,13}
	charToInts[']']={3,14}
	charToInts['"']={3,15}
	charToInts['A']={4,1}
	charToInts['B']={4,2}
	charToInts['C']={4,3}
	charToInts['D']={4,4}
	charToInts['E']={4,5}
	charToInts['F']={4,6}
	charToInts['G']={4,7}
	charToInts['H']={4,8}
	charToInts['I']={4,9}
	charToInts['J']={4,10}
	charToInts['K']={4,11}
	charToInts['L']={4,12}
	charToInts['M']={4,13}
	charToInts['N']={4,14}
	charToInts['O']={4,15}
	charToInts['P']={5,1}
	charToInts['Q']={5,2}
	charToInts['R']={5,3}
	charToInts['S']={5,4}
	charToInts['T']={5,5}
	charToInts['U']={5,6}
	charToInts['V']={5,7}
	charToInts['W']={5,8}
	charToInts['X']={5,9}
	charToInts['Y']={5,10}
	charToInts['Z']={5,11}
	charToInts['(']={5,12}
	charToInts[')']={5,13}
	charToInts['_']={5,14}
	charToInts[',']={5,15}
	charToInts['1']={6,1}
	charToInts['2']={6,2}
	charToInts['3']={6,3}
	charToInts['4']={6,4}
	charToInts['5']={6,5}
	charToInts['6']={6,6}
	charToInts['7']={6,7}
	charToInts['8']={6,8}
	charToInts['9']={6,9}
	charToInts['0']={6,10}
end
initCommunication()


function comm_sendMessage (message)
	log("Sending Message")
	for i=1,string.len(message) do
		local char=message:sub(i,i)
		local nums=charToInts[char]
		if nums == nil then
			log("Error: Unknown char: "..char..".")
			error("Unknown Char in Message")
		end
		comm_send(nums[1])
		comm_send(nums[2])
	end
	comm_send(15)
	comm_send(15)
	log("Sent Message")
end

function comm_getMessage ()
	log("Receiving Message")
	local str=''
	local char1= comm_read()
	local char2= comm_read()
	local i = 0
	while (char1~=15 or char2~=15) do
		str=str..intsToChar[char1][char2]
		term.write(intsToChar[char1][char2])
		char1= comm_read()
		char2= comm_read()
		i = i+ 1
		if i % 39 == 0 then
			print()
			--term.write(i)
		end
	end
	print()
	log("Received Message")
	log(str)
	return str
end

function comm_send (number)
	redstone.setAnalogOutput("front", number)
	while (not redstone.getInput("front")) do
		os.sleep(0.05)
	end
	redstone.setOutput("front", false)

	while (redstone.getInput("front")) do
		os.sleep(0.05)
	end
end

function comm_read ()
	while (not redstone.getInput("front")) do
		os.sleep(0.05)
	end
	local num = redstone.getAnalogInput("front")
	redstone.setOutput("front", true)
	while (redstone.getInput("front")) do
		os.sleep(0.05)
	end
	redstone.setOutput("front", false)
	return num
end

function comm_test1()
	local str = ""
	for _,i in pairs(intsToChar) do
		for _,j in pairs(i) do
			str = str..j
		end
	end
	log("Sending: "..str)
	comm_sendMessage(str)
	local str2 = comm_getMessage()
	log("Got: "..str2)
	log("Is equal:")
	log(str==str2)
end

function comm_echo()
	local tmp = comm_getMessage()
	sleep(1)
	comm_sendMessage(tmp)
end
