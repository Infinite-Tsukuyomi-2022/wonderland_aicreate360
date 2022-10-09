#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import csv

address_path  = "data/address.txt"
raw_address = []

with open(address_path) as f:
    for line in f.readlines():
        s = line.split("\n")
        raw_address.append(str(s[0]))

quantity = []
address = []

for i in range(len(raw_address)):
    address.append("\'" + str(raw_address[i]) + "\'")


for i in range(len(address)):
    quantity.append(1)

with open('data/airdrop_address_1.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[0:50])

with open('data/airdrop_quantity_1.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[0:50])

with open('data/airdrop_address_2.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[50:100])

with open('data/airdrop_quantity_2.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[50:100])

with open('data/airdrop_address_3.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[100:150])

with open('data/airdrop_quantity_3.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[100:150])

with open('data/airdrop_address_4.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[150:200])

with open('data/airdrop_quantity_4.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[150:200])

with open('data/airdrop_address_5.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[200:250])

with open('data/airdrop_quantity_5.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[200:250])

with open('data/airdrop_address_6.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[250:300])

with open('data/airdrop_quantity_6.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[250:300])

with open('data/airdrop_address_7.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[300:350])

with open('data/airdrop_quantity_7.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[300:350])

with open('data/airdrop_address_8.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(address[350:])

with open('data/airdrop_quantity_8.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(quantity[350:])