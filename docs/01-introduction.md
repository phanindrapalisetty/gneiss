# Introduction

| Property | Value |
|-|-|
| Status | Complete |
| Project | Gneiss |



# Purpose

Introduce the Gneiss project, its objectives, architecture and guiding principles.



# Scope

This document explains:

- What Gneiss is
- Why it exists
- High-level architecture
- Design philosophy

It does not explain installation or configuration.



# What is Gneiss?

Gneiss is a self-hosted homelab platform built using repurposed consumer hardware.

The objective is to create a reliable platform for:

- Personal cloud
- Media streaming
- Data engineering
- Infrastructure learning
- Linux administration



# Design Principles

## Documentation First

Every change must be documented before or immediately after implementation.



## Infrastructure as Code

Configuration should be reproducible.

Manual changes should be avoided whenever practical.



## Keep It Simple

Avoid unnecessary complexity until there is a clear requirement.



## Modular Architecture

Every service should be independently deployable.



## Learning by Building

The project exists primarily as a learning platform.



# Architecture

```text
MacBook
    │
 SSH
    │
Debian
    │
Docker
    │
Services
```



# Project Goals

- Build a reliable home server
- Learn Docker
- Learn Linux
- Learn Networking
- Learn Storage
- Build a local analytics platform



# Next Step

Proceed to:

docs/02-installation.md