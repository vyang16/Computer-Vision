%Exercise 8 Shape Matching
%Viviane Yang 16-944-530
clear all;
close all;
dataset_name = "dataset.mat";
dataset = load(dataset_name);
objects = dataset.objects;
obj1 = objects(1);
obj2 = objects(2);

figure(20) 
imshow(obj1.img)
figure(21)
imshow(obj2.img)

cost = shape_matching(obj1.X, obj2.X, 1);