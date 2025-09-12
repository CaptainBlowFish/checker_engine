import pygame

class billBoard:
    """The billboard class"""

    def __init__(self, game, msg):
        """Initilize billboard attributes."""
        self.screen = game.screen
        self.screen_rect = self.screen.get_rect()

        # Set the dimensions and properties of the button
        self.width, self.height = 150, 100
        self.color = (255, 255, 255)
        self.text_color = (0, 0, 0)
        self.font = pygame.font.SysFont(None, 40)

        # Build the billboard's rect object and center it 
        self.rect = pygame.Rect(400, 0, self.width, self.height)

        # The button message need to be prepped 
        self._prep_msg(msg)

    def _prep_msg(self, msg):
        """turn the msg into a rentered image and center text on the button"""
        self.msg_image = self.font.render(msg, True, self.text_color, self.color)
        self.msg_image_rect = self.msg_image.get_rect()
        self.msg_image_rect.center = self.rect.center

    def draw(self):
        """Draw blank button and then draw message."""
        self.screen.fill(self.color, self.rect)
        self.screen.blit(self.msg_image, self.msg_image_rect)