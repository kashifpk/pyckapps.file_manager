from sqlalchemy import Column, Unicode
from . import db, Base


class Place(Base):
   __tablename__ = 'places'
   path = Column(Unicode(1000), primary_key=True)
   name = Column(Unicode(100), unique=True)
   description = Column(Unicode(1000))
