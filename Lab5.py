from web3 import Web3
import statistics
import matplotlib.pyplot as plt
import numpy

K = 24
# K = 53 for Sveta
block = 8961400
startPoint = block - 1000*(K-1)
endPoint = block - 1000*(K-2)

#   В каждом блоке есть список транзакций.
#   Необходимо посчитать общую комисссию в эфире по каждому блоку и, зная награду за блок, определить какой процент составляет комиссия от общей награды майнеру.
#   Выведите отдельно графики с абсолютными значениями и относительными.
#   Посчитайте математическое ожидание, медиану, размах, среднеквадратическое отклонение и дисперсию значения комиссии.
#   Учтите, что gas != количеству эфира (см. gasPrice)
#   Доп. задание. Определить количество обращений к смарт контрактам (см. поле 'input')

web3 = Web3(Web3.HTTPProvider("https://mainnet.infura.io/v3/ecd562df84704d8f9ddfcd4ede916c6f"))

Blocks = []
Percent = []
Ethers = []
Rewards = []
Contracts = 0

Number = 0
for x in range(startPoint, endPoint+1):
    Number += 1
    print(Number)
    block = web3.eth.getBlock(x)
    ether = 0
    gasPrice = 0
    for y in block.transactions:
        trans = web3.eth.getTransaction(y.hex())
        transRec = web3.eth.getTransactionReceipt(y.hex())
        ether += (float(transRec.gasUsed)*float(trans.gasPrice)/(10**18))
        gasPrice += trans.gasPrice
        if trans.input != '0x': Contracts += 1
    if len(block.transactions)==0: blockReward=2
    else: blockReward = 2 + (block.gasUsed*(gasPrice/len(block.transactions)))/(10**18)

    Blocks.append(x)
    Ethers.append(ether)
    Rewards.append(blockReward)
    Percent.append(ether/blockReward*100)

MatExp = statistics.mean(Ethers)
Median = statistics.median(Ethers)
Range = max(Ethers) - min(Ethers)
Deviation = numpy.std(Ethers)
Dispersion = numpy.var(Ethers)

text1 = ("Мат. ожидание комиссии = "+ str(MatExp))
text2 = ("Медиана комиссии = "+ str(Median))
text3 = ("Размах комиссии = "+ str(Range))
text4 = ("Ср. кв. отклонение комиссии = "+ str(Deviation))
text5 = ("Дисперсия комиссии = "+ str(Dispersion))
text6 = ("Количество обращений к смарт контрактам = "+ str(Contracts))

fig, axs = plt.subplots(2, 2, figsize=(12, 8), sharey=False)
axs[0][0].scatter(Blocks, Percent)
axs[0][0].set_title('Комиссия по блокам в процентах')
axs[0][0].set_xlabel('Номера блоков')
axs[0][0].set_ylabel('Комиссия, %')
axs[0][1].scatter(Blocks, Ethers)
axs[0][1].set_title('Комисссия по блокам в абсолютных величинах')
axs[0][1].set_xlabel('Номера блоков')
axs[0][1].set_ylabel('Комиссия, Eth')
axs[1][0].scatter(Rewards, Percent)
axs[1][0].set_title('Комиссия от награды в процентах')
axs[1][0].set_xlabel('Награда, Eth')
axs[1][0].set_ylabel('Комиссия, %')
#axs[1][1].scatter(Rewards, Ethers)
#axs[1][1].set_title('Комиссия от награды в эфирах')
#axs[1][1].set_xlabel('Награда, Eth')
#axs[1][1].set_ylabel('Комиссия, Eth')
axs[1][1].text(0, 0.9, text1, ha='left', wrap=True)
axs[1][1].text(0, 0.75, text2, ha='left', wrap=True)
axs[1][1].text(0, 0.6, text3, ha='left', wrap=True)
axs[1][1].text(0, 0.45, text4, ha='left', wrap=True)
axs[1][1].text(0, 0.3, text5, ha='left', wrap=True)
axs[1][1].text(0, 0.15, text6, ha='left', wrap=True)
axs[1][1].set_axis_off()
fig.subplots_adjust(left=0.08, right=0.92, bottom=0.08, top=0.95, hspace=0.3, wspace=0.3)
plt.show()