charToInts = {}
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
charToInts['p']={1,16}
charToInts['q']={2,1}
charToInts['r']={2,2}
charToInts['s']={2,3}
charToInts['t']={2,4}
charToInts['u']={2,5}
charToInts['v']={2,6}
charToInts['w']={2,7}
charToInts['x']={2,8}
charToInts['y']={2,9}
charToInts['z']={2,10}
charToInts[' ']={2,11}
charToInts['!']={2,12}
charToInts['.']={2,13}
charToInts['?']={2,14}
charToInts['#']={2,15}
charToInts['+']={2,16}
charToInts['-']={3,1}
charToInts['*']={3,2}
charToInts['/']={3,3}
charToInts['$']={3,4}
intsToChar={{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p'},{'q','r','s','t','u','v','w','x','y','z',' ','!','.','?','#','+'},{'-','*','/','$'}}


function sendMessage (message)
	for i=1,string.len(message) do
		local char=message:sub(i,i)
		local nums=charToInts[char]
		send(nums[1])
		send(nums[2])
	end
	send(15)
	send(15)
end

function getMessage ()
	local str=''
	local char1=read()
	local char2=read()
	while (char1~=15 or char2~=15) do
		str=str..intsToChar[char1][char2]
		char1=read()
		char2=read()
	end
	return str
end

function send (number)
	redstone.setAnalogOutput("front", number)
	
	redstone.setOutput("top", true)
	
	while (not redstone.getInput("bottom")) do
		os.sleep(0.05)
	end

	redstone.setOutput("top", false)

	while (redstone.getInput("bottom")) do
		os.sleep(0.05)
	end
end


function read ()
	while (not redstone.getInput("top")) do
		os.sleep(0.05)
	end

	local num = redstone.getAnalogInput("front")

	redstone.setOutput("bottom", true)


	while (redstone.getInput("top")) do
		os.sleep(0.05)
	end

	redstone.setOutput("bottom", false)
	return num
end


